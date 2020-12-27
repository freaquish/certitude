from insight.models import *
from insight.utils import get_ist, json_to_coord, post_id_generator
from django.db.models import Q, QuerySet
from insight.workers.interface import PostCreationInterface
from insight.workers.analyzer import Analyzer
from celery import shared_task
from insight.competitions.main import CompetitionManager


class PostCreationManager(PostCreationInterface):
    post = None
    analyzer = None
    hash_tags = []
    a_tags = []
    competition_manager = None
    competitions = None

    def render_data(self) -> dict:
        # print(self.map('hobby'))
        hobbies: QuerySet = Hobby.objects.filter(code_name=self.map('hobby'))
        # print(hobbies)
        if not hobbies.exists():
            return None
        data: dict = self.kwargs.copy()
        if 'coords' in self.kwargs:
            self.user.insert_coords(json_to_coord(self.map('coords')))
            self.user.save()
            data['coordinates'] = json_to_coord(self.map('coords'))
        self.hash_tags = data['hastags']
        self.a_tags = data['atags']
        del data['hastags']
        del data['atags']
        data['created_at'] = get_ist()
        data['post_id'] = post_id_generator()
        data['account'] = self.user
        data['hobby'] = hobbies.first()
        data['is_global'] = False if self.map('is_global') == 0 else True
        # print('Inside render data', data)
        return data

    def before_creation(self, **data):
        """
        Certain operations required to be called before post creations
        """
        self.competition_manager: CompetitionManager = CompetitionManager(self.user)
        self.competitions, dates = self.competition_manager.submittable_competitions(**data)
        data.update(dates)
        return data

    def create_post(self):
        data: dict = self.render_data()
        if data is None:
            return data
        try:
            if 'competition_tags' in data and len(data['competition_tags']) > 0:
                data = self.before_creation(**data)
            self.post: Post = Post.objects.create(**data)
            self.after_creation()
        except AssertionError:
            return None

    @staticmethod
    def sanitize_tag(tag: str) -> str:
        if '@' in tag:
            return tag.replace('@', '')
        elif '#' in tag:
            return tag.replace('#', '')

    def create_tag(self):

        all_tags = self.a_tags + self.hash_tags
        if len(all_tags) == 0:
            return None
        tag_query = None
        for tag in all_tags:
            if tag_query:
                tag_query = tag_query | Q(Q(tag=self.sanitize_tag(tag)) & Q(tag_type=A_TAG if tag[0] == '@' else HASH))
            else:
                tag_query = Q(Q(tag=self.sanitize_tag(tag)) & Q(tag_type=A_TAG if tag[0] == '@' else HASH))
        if tag_query:
            tags_in_db: QuerySet = Tags.objects.filter(tag_query).values_list('tag', flat=True)

            tags_not_in_db = filter(lambda lam_tag: self.sanitize_tag(lam_tag) not in tags_in_db,  all_tags)
            tags = [Tags(tag=self.sanitize_tag(tag), created_at=get_ist(), tag_type=A_TAG if '@' in tag else HASH,
                         first_used=self.post.post_id) for tag in tags_not_in_db]
            # print(tags_in_db, tags_not_in_db, tags)
            Tags.objects.bulk_create(
                tags
            )
            current_tags_in_db: QuerySet = Tags.objects.filter(tag_query)
            # print(current_tags_in_db)
            self.post.hash_tags.set(current_tags_in_db.filter(tag_type=HASH))
            self.post.a_tags.set(current_tags_in_db.filter(tag_type=A_TAG))
            return None
        return None

    def attach_to_competition(self):
        """
        Attach the post to competition by calling  add_post method from competition manager
        """
        if self.competition_manager is None or self.competitions is None or not self.competitions.exists():
            return None
        self.competition_manager.add_post(self.post, self.competitions)

    def after_creation(self):
        if self.post is None:
            return None
        self.create_tag()
        self.attach_to_competition()
        self.analyzer = Analyzer(self.post.account)
        self.analyzer.analyzer_create_post(self.post)
