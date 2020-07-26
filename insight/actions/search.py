from insight.models import *
from django.db.models import Q, QuerySet
from django.db.models import DecimalField, F, ExpressionWrapper, Value
from django.db.models.functions import Concat
from django.contrib.postgres.search import SearchQuery, SearchRank, SearchVector


class Search:

    def __init__(self, **kwargs):
        if kwargs:
            if 'account_id' in kwargs:
                self.account_id = kwargs['account_id']
            if 'account' in kwargs:
                self.account = kwargs['account']
            else:
                self.account = None
            if 'query' in kwargs:
                self.query = kwargs['query']

    def search_tags(self):
        return Tags.objects.filter(Q(tag__search=self.query)).annotate(rank=SearchRank(SearchVector('tag'),
                                                                                       SearchQuery(
                                                                                           self.query))).order_by(
            '-rank')

    def search_accounts(self):
        vector = SearchVector('first_name') + SearchVector('last_name')
        query = SearchQuery(self.query)
        if not self.account:
            return Account.objects.annotate(full_name=Concat('first_name', Value(' '), 'last_name')).filter(
                full_name__search=self.query
            ).annotate(rank=SearchRank(vector, query)).order_by('-rank', '-influencer')
        else:
            return Account.objects.annotate(full_name=Concat('first_name', Value(' '), 'last_name')).filter(
                full_name__search=self.query
            ).annotate(rank=SearchRank(vector, query),
                       hobby_distance=ExpressionWrapper(F('primary_weight') - DecimalField(self.account.primary_weight))
                       ).order_by('-rank', '-influencer', '-hobby_distance')

    def search_hobby(self):
        vector = SearchVector('name')
        query = SearchQuery(self.query)
        return Hobby.objects.filter(name__search=self.query).annotate(rank=SearchRank(vector, query)).order_by('-rank')
