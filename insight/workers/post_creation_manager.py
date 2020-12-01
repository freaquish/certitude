from insight.models import *
from insight.utils import get_ist, json_to_coord, post_id_generator
from django.db.models import Q, QuerySet
from insight.workers.interface import PostCreationInterface
from insight.workers.analyzer import Analyzer
from celery import shared_task


class PostCreationManager(PostCreationInterface):
    post = None
    analyzer = None
    hash_tags = []
    a_tags = []

    def render_data(self) -> dict:
        hobbies: QuerySet = Hobby.objects.filter(code_name=self.map('hobby'))
        if not hobbies:
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
        return data

    def create_post(self):
        data: dict = self.render_data()
        if data is None:
            return data
        self.post: Post = Post.objects.create(**data)
        self.after_creation()

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
                tag_query = tag_query | Q(tag=self.sanitize_tag(tag))
            else:
                tag_query = Q(tag=tag)
        if tag_query:
            tags_in_db: QuerySet = Tags.objects.filter(tag_query).values_list('tag', flat=True)
            tags_not_in_db = set([self.sanitize_tag(tag) for tag in all_tags]).difference(set(tags_in_db))
            Tags.objects.bulk_create(
                [Tags(tag=self.sanitize_tag(tag), created_at=get_ist(), tag_type=A_TAG if '@' in tag else HASH,
                      first_used=self.post.post_id) for tag in tags_not_in_db]
            )
            tags_in_db: QuerySet = Tags.objects.filter(tag_query)
            # TODO: Watch Python Compilation
            # print(tags_in_db)
            self.post.hash_tags.set(tags_in_db.filter(tag_type=HASH))
            self.post.a_tags.set(tags_in_db.filter(tag_type=A_TAG))
            return tags_in_db

    def after_creation(self):
        if self.post is None:
            return None
        tags: QuerySet = self.create_tag()
        self.analyzer = Analyzer(self.post.account)
        self.analyzer.analyzer_create_post(self.post)















