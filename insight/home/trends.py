from insight import models
from django.db.models import Q, QuerySet, ExpressionWrapper, F, Value, OuterRef, Subquery
from django.db.models.fields import DecimalField
from django.db.models.functions import Exp, ExtractDay, Now
from insight.home.interface import TrendsInterface

"""
Class Lacks much needed personalisation which will be improvised
later Nearest Hobby Algorithm should be implemented soon
"""


class Trends(TrendsInterface):

    def extract_trending_in_hobby_user(self, *hobbies) -> Q:
        report_weights: QuerySet = models.HobbyReport.objects.filter(account=self.account).select_related('hobby') \
            .values_list('hobby__weight', flat=True)
        hobby_query = None
        for weight in report_weights.iterator():
            query = Q(weight__gte=abs(float(weight) - 3.0)) & Q(weight__lte=abs(float(weight) + 3.0))
            if hobby_query:
                hobby_query = hobby_query | query
            else:
                hobby_query = query
        if hobby_query is not None:
            hobbies: QuerySet = models.Hobby.objects.filter(hobby_query).values_list('code_name', flat=True)
            required_hobbies = None
            for hobby in hobbies:
                if required_hobbies:
                    required_hobbies = required_hobbies | Q(hobby__code_name=hobby)
                else:
                    required_hobbies = Q(hobby__code_name=hobby)
            if required_hobbies is not None:
                return required_hobbies
            return None
        return None

    def extract_queryset(self, query: Q) -> QuerySet:
        score_expression: ExpressionWrapper = ExpressionWrapper(
            Exp(ExpressionWrapper(Value(1 / 4) * ExtractDay('created_at') - ExtractDay(Now()) + Value(0.8),
                                  output_field=DecimalField())) +
            ExpressionWrapper(Value(0.01) * F('score'), output_field=DecimalField())
            , output_field=DecimalField()
        )
        annotation = {'current_score': score_expression}
        if query:
            posts: QuerySet = models.Post.objects.select_related("account", "hobby").prefetch_related('views', 'loves',
                                                                                                      'shares'). \
                filter(query).annotate(**annotation)
        else:
            posts: QuerySet = models.Post.objects.annotate(**annotation)
        return posts
