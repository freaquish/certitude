from insight.models import *
from django.db.models import Q, QuerySet
from django.contrib.postgres.search import SearchQuery, SearchRank, SearchVector

"""
 search atags : Post containing atags, Account, community, competiton related with query
 search hastags
 search first_name, last_name
 search hobby
 search competition
 search community
"""


class SearchEngine:
    def __init__(self, user, query: str):
        self.user: Account = user
        self.query: str = query

    @staticmethod
    def sanitize_query(query: str):
        if '@' in query:
            return query.replace('@', '')
        elif '#' in query:
            return query.replace('#', '')

    def search_user(self):
        vector = SearchVector('username', 'first_name', 'last_name')
        query = SearchQuery(self.sanitize_query(self.query))
        return Account.objects.annotate(rank=SearchRank(vector, query)).order_by('-rank')

    def search_hobby(self):
        return Hobby.objects.filter(name__search=self.sanitize_query(self.query))

    def search_tags(self):
        return Tags.objects.filter(tag__search=self.query)

    def get_tag_related_post(self):
        # TODO: Sophisticated and optimised model for post-tag relations
        if '#' in self.query:
            return Post.objects.filter(hastags__contains=[self.query]).order_by('-created_at', 'score')
        elif '@' in self.query:
            return Post.objects.filter(atags__contains=[self.query]).order_by('-created_at', 'score')

    def get_hobby_related_post(self):
        return Post.objects.filter(hobby__code_name=self.query).order_by('-created_at', 'score')
