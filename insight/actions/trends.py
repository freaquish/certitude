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

    def extract_post_trending_query(self, *val) -> Q:
        return Q(net_score__gte=val if len(val) != 0 else 1.3)

    def extract_trending_in_hobby(self, query: Q, *hobbies) -> Q:
        hobby_query = None
        for hobby in hobbies:
            if hobby_query:
                hobby_query = hobby_query | Q(post__hobby__code_name=hobby)
            else:
                hobby_query = Q(post__hobby__code_name=hobby)
        if hobby_query:
            return query & hobby_query
        return query

    def extract_queryset(self, *query: Q) -> QuerySet:
        score_expression: ExpressionWrapper = ExpressionWrapper(
                Exp(ExpressionWrapper(Value(1/4) * ExtractDay('created_at') - ExtractDay(Now()) + Value(0.8) + F('score'),
                                      output_field=DecimalField())), output_field=DecimalField()
            )
        annote = {'current_score': score_expression}
        score_posts: QuerySet = models.ScorePost.objects.annotate(**annote).select_related('post')
        return score_posts

    def get_posts(self, queryset: QuerySet):
        if self.account:
            post_query = None
            posts = []
            for score_post in queryset:
                posts.append(score_post.post)
                if post_query:
                    post_query = post_query | Q(post_id=score_post.post.post_id)
                else:
                    post_query = Q(post_id=score_post.post.post_id)
            if post_query:
                return queryset, models.ActionStore.objects.filter(Q(account_id=self.account.account_id) & post_query)
            return queryset
        return queryset
