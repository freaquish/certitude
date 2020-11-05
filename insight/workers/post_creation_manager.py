from insight.models import *
from insight.utils import get_ist, json_to_coord, post_id_generator
from django.db.models import Q, QuerySet
from insight.workers.interface import PostCreationInterface
from insight.workers.analyzer import Analyzer


class PostCreationManager(PostCreationInterface):
    post = None
    analyzer = None

    def render_data(self) -> dict:
        hobbies: QuerySet = Hobby.objects.filter(code_name=self.map('hobby'))
        if not hobbies:
            return None
        data: dict = self.kwargs.copy()
        if 'coords' in self.kwargs:
            self.user.insert_coords(json_to_coord(self.map('coords')))
            self.user.save()
            data['coords'] = json_to_coord(self.map('coords'))
        data['created_at'] = get_ist()
        data['post_id'] = post_id_generator()
        data['account'] = self.user
        data['hobby'] = hobbies.first()
        data['is_global'] = False if self.map('is_global') == 0 else True
        data['action_count'] = {'love': 0, 'view': 0, 'share': 0, 'comment': 0, 'up_vote': 0, 'save': 0, 'down_vote': 0}
        return data

    def create_post(self):
        data: dict = self.render_data()
        if data is None:
            return data
        self.post: Post = Post.create_new(**data)
        self.after_creation()

    def create_tag(self):
        all_tags = self.post.atags + self.post.hastags
        if len(all_tags) == 0:
            return None
        tag_query = None
        for tag in all_tags:
            if tag_query:
                tag_query = tag_query | Q(tag=tag)
            else:
                tag_query = Q(tag=tag)
        if tag_query:
            tags_in_db: QuerySet = Tags.objects.filter(tag_query).values_list('tag', flat=True)
            tags_not_in_db = set(all_tags).difference(set(tags_in_db))
            Tags.objects.bulk_create(
                [Tags(tag=tag, created_at=get_ist(), first_used=self.post.post_id) for tag in tags_not_in_db]
            )

    def after_creation(self):
        if self.post is None:
            return None
        self.analyzer = Analyzer(self.post.account)
        self.create_tag()
        self.analyzer.manage_score_post(self.post, is_new=True)
        # data = self.attach_to_competition()
        # self.attach_to_community(data)
        self.analyzer.background_task.delay(self.post.account.account_id, hobby=self.post.hobby.code_name,
                                            report={'posts': 1})











