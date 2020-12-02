from insight import models
from django.db.models import Q, QuerySet, ExpressionWrapper, F, Value, OuterRef, Subquery, DurationField, DateTimeField
from django.db.models.fields import DecimalField
from django.db.models.functions import Exp, ExtractDay, Now, Trunc
from insight.home.interface import TrendsInterface
from typing import *

"""
Class Lacks much needed personalisation which will be improvised
later Nearest Hobby Algorithm should be implemented soon
"""


class Trends(TrendsInterface):

    def extract_trending_in_hobby_user(self, *hobbies) -> Tuple:
        score_expression: ExpressionWrapper = ExpressionWrapper(
            ExpressionWrapper(Value(self.WEIGHT_POST) * F('posts'), output_field=DecimalField()) +
            ExpressionWrapper(Value(self.WEIGHT_VIEW) * F('views'), output_field=DecimalField()) +
            ExpressionWrapper(Value(self.WEIGHT_LOVE) * F('loves'), output_field=DecimalField()) +
            ExpressionWrapper(Value(self.WEIGHT_SHARE) * F('shares'), output_field=DecimalField()) +
            ExpressionWrapper(Value(self.WEIGHT_COMMENTS) * F('comments'), output_field=DecimalField()),
            output_field=DecimalField()
        )
        report_weights: QuerySet = models.HobbyReport.objects.filter(account=self.account).select_related('hobby') \
            .annotate(score=score_expression)
        hobby_query = None
        for weight in report_weights.values_list('hobby__weight', flat=True).iterator():
            query = Q(weight__gte=abs(float(weight) - 1.8)) & Q(weight__lte=abs(float(weight) + 1.8))
            if hobby_query:
                hobby_query = hobby_query | query
            else:
                hobby_query = query
        if hobby_query is not None:
            subquery: Subquery = Subquery(report_weights.filter(hobby__code_name=OuterRef('code_name')) \
                                          .values_list('score', flat=True)[:1])
            hobbies: QuerySet = models.Hobby.objects.filter(hobby_query).annotate(
                hobby_score=subquery,
            )
            required_hobbies = None
            for hobby in hobbies.values_list('code_name', flat=True).iterator():
                if required_hobbies:
                    required_hobbies = required_hobbies | Q(hobby__code_name=hobby)
                else:
                    required_hobbies = Q(hobby__code_name=hobby)
            if required_hobbies is not None:
                return required_hobbies, hobbies
            return None
        return None

    def most_followed_user(self):
        if not isinstance(self.account, models.Account):
            return None
        # users_post_seen: QuerySet = models.Post.objects.filter(views__account_id=self.account.account_id)
        followings: QuerySet = models.Account.objects.filter(account_id__in=self.account.following)
        if not followings.exists():
            return None

    def extract_queryset(self, *queries: Tuple) -> QuerySet:

        time_wrapper: ExpressionWrapper = ExpressionWrapper(
            Trunc('created_at', 'second', output_field=DateTimeField()) -
            Trunc(Now(), 'second', output_field=DateTimeField()),
            output_field=DurationField()
        )
        score_expression: ExpressionWrapper = ExpressionWrapper(
            Exp(ExpressionWrapper(Value(1 / 4) * F('duration'),
                                  output_field=DecimalField())) + Value(0.8) +
            ExpressionWrapper(Value(0.01) * F('score'), output_field=DecimalField())
            , output_field=DecimalField()
        )
        annotation = {'duration': ExtractDay(time_wrapper),
                      'current_score': score_expression}
        if len(queries) > 0:
            query = queries[0]
            annotation['hobby_score'] = Subquery(query[1].filter(code_name=OuterRef('hobby__code_name'))
                                                 .values_list('hobby_score', flat=True)[:1])
            posts: QuerySet = models.Post.objects.select_related("account", "hobby").prefetch_related('views', 'loves',
                                                                                                      'shares'). \
                filter(query[0]).annotate(**annotation).exclude(hobby_score=None)
        else:
            annotation['hobby_score'] = ExpressionWrapper(Value(0.0), output_field=DecimalField())
            posts: QuerySet = models.Post.objects.annotate(**annotation)
        return posts
