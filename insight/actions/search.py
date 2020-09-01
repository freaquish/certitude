from insight.models import *
from django.db.models import Q, QuerySet
from django.db.models import DecimalField, F, ExpressionWrapper, Value
from django.db.models.functions import Concat
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
        return Account.objects.filter(Q(username__search=query))
