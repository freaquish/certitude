from insight import models
from django.db.models import Q, QuerySet, ExpressionWrapper, F, Value, OuterRef, Subquery
from django.db.models.fields import DecimalField
from django.db.models.functions import Exp, ExtractDay, Now
from insight.actions.interface import TrendsInterface

"""
Class Lacks much needed personalisation which will be improvised
later Nearest Hobby Algorithm should be implemented soon
"""


class Trends(TrendsInterface):

    def extract_trending_in_hobby_user(self, *hobbies) -> Q:
        report_weights: QuerySet = models.HobbyReport.objects.filter(account=self.account).select_related('hobby')\
            .values_list('hobby__weight', flat=True)
        hobby_query = None
        for weight in report_weights:
            query = Q(weight__gte=abs(float(weight) - 3.0)) & Q(weight__lte=abs(float(weight) + 3.0))
            if hobby_query:
                hobby_query = hobby_query | query
            else:
                hobby_query = query
        if hobby_query:
            hobbies: QuerySet = models.Hobby.objects.filter(hobby_query).values_list('code_name', flat=True)
            required_hobbies = None
            for hobby in hobbies:
                if required_hobbies:
                    required_hobbies = required_hobbies | Q(post__hobby__code_name=hobby)
                else:
                    required_hobbies = Q(post__hobby__code_name=hobby)
            if required_hobbies:
                return required_hobbies
            return None
        return None

    def extract_queryset(self, *query: Q) -> QuerySet:
        score_expression: ExpressionWrapper = ExpressionWrapper(
                Exp(ExpressionWrapper(Value(1/4) * ExtractDay('created_at') - ExtractDay(Now()) + Value(0.8) + F('score'),
                                      output_field=DecimalField())), output_field=DecimalField()
            )
        annote = {'current_score': score_expression}
        if query:
            score_posts: QuerySet = models.ScorePost.objects.filter(query[0]).annotate(**annote).select_related('post')
        else:
            score_posts: QuerySet = models.ScorePost.objects.annotate(**annote).select_related('post')
        return score_posts

    def get_posts(self, queryset: QuerySet):
        if self.account:
            post_query = None
            for score_post in queryset:
                if post_query:
                    post_query = post_query | Q(post_id=score_post.post.post_id)
                else:
                    post_query = Q(post_id=score_post.post.post_id)
            if post_query:
                return queryset, models.ActionStore.objects.filter(Q(account_id=self.account.account_id) & post_query)
            return queryset
        return queryset
