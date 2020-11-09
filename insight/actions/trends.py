from insight import models
from django.db.models import Q, QuerySet, ExpressionWrapper, F, Value
from django.db.models.fields import DecimalField, IntegerField
from django.db.models.functions import Exp
from insight.utils import get_ist, timedelta
from insight.actions.interface import TrendsInterface

"""
Class Lacks much needed personalisation which will be improvised
later Nearest Hobby Algorithm should be implemented soon
"""


class Trends(TrendsInterface):

    def __init__(self, *account):
        self.account = None
        if account:
            self.account: models.Account = account[0]
            super().__init__(self.account)

    def extract_top_hobby_post(self, hobby_codes: dict, queryset: QuerySet = None) -> Q:
        hobby_query = None
        for key in hobby_codes.keys():
            if hobby_query:
                hobby_query = hobby_query | Q(post__hobby__code_name=key)
            else:
                hobby_query = Q(post__hobby_code_name=key)
        return hobby_query

    def extract_new_posts(self) -> Q:
        return Q()

    def annotate_interface_formula(self, queryset: QuerySet, follower_weight: float = 0.0) -> QuerySet:
        hobby_reports = models.HobbyReport.objects.filter(account=self.account)
        if hobby_reports:
            hobby_report: models.HobbyReport = hobby_reports.first()
            hobby_expression: Exp = Exp(ExpressionWrapper(Value(0.1) *
                                                          ExpressionWrapper(F('views') + F('loves') + F('shares'),
                                                                            output_field=IntegerField()),
                                                          output_field=DecimalField()))
        else:
            action_stores = models.ActionStore.objects.filter(account_id=self.account.account_id)
            if not action_stores:
                hobby_expression: Exp(Value(0))
            hobby_expression: Exp = Exp(Value(0.1) * ExpressionWrapper(
                Value(len(action_stores.filter(loved=True))) + Value(len(action_stores.filter(viewed=True))) +
                Value(len(action_stores.filter(shared=True))), output_field=IntegerField()))
        freshness_expression: Exp = Exp(Value(-1) * F('freshness_score'))
        interface_expression: ExpressionWrapper = ExpressionWrapper(freshness_expression * hobby_report * F('score'),
                                                                    output_field=DecimalField())
        annotated: QuerySet = queryset.annotate(interface_score=interface_expression)
        return annotated

    def extract_followings_post(self) -> Q:
        query = None
        for followee in self.account.following:
            if query:
                query = query | Q(post__account__acount_id=followee)
            else:
                query = Q(post__account__account_id=followee)
        return query

    def extract_top_ranked_for_unknown(self) -> Q:
        # TODO: Need to restrict no of posts after total posts crosses 1000 for now 30days old
        return Q(post__created_at__gte=get_ist() - timedelta(days=30))

    def render_posts(self) -> QuerySet:
        query_set: QuerySet = models.ScorePost.objects.filter(self.extract_top_ranked_for_unknown() &
                                                              self.extract_followings_post())
        if self.account:
            hobby_query: Q = self.extract_top_hobby_post(self.account.hobby_map)
            if hobby_query:
                hobby_query_set: QuerySet = query_set.filter(hobby_query)
            annotated_queryset: QuerySet = self.annotate_interface_formula(query_set)
            sorted_queryset: QuerySet = annotated_queryset.order_by('interface_score')
            # Exclusion of post within 1 day, last online will be used
            action_stores: QuerySet = models.ActionStore.objects.filter(Q(account_id=self) &
                                                                        Q(viewed_at__gte=get_ist() - timedelta(days=1))) \
                .values_list('post_id')
            sorted_queryset = sorted_queryset.exclude(post__post_id__in=action_stores)
            return sorted_queryset
        else:
            return query_set
