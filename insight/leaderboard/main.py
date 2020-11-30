"""
Comments about a shit piece of program written just to workout in the current scene
@Author: Piyush Jaiswal
@email: iampiyushjaiswal103@gmail.com
@collaborator: Suyash Madhesia

Visit insight.algol.Leaderboard
"""
from django.db.models import Q, Window, F, Count, Sum, ExpressionWrapper, DecimalField, Value
from django.db.models.functions import DenseRank
from fuzzywuzzy import fuzz
from insight.leaderboard.interface import *
from insight.workers.interface import AnalyzerInterface


class LeaderboardEngine(LeaderboardEngineInterface):
    query = Q(expires_on__gte=get_ist().date()) & Q(created_at__lte=get_ist().date())

    @staticmethod
    def ranking(string: str) -> Window:
        return Window(
            expression=DenseRank(),
            order_by=F(string).desc()
        )

    @staticmethod
    def net_score() -> ExpressionWrapper:
        return ExpressionWrapper(
            ExpressionWrapper(
                Value(AnalyzerInterface.WEIGHT_VIEW) * F('views'), output_field=DecimalField()
            ) + ExpressionWrapper(
                Value(AnalyzerInterface.WEIGHT_SHARE) * F('loves'), output_field=DecimalField()
            ) + ExpressionWrapper(
                Value(AnalyzerInterface.WEIGHT_SHARE) * F('shares'), output_field=DecimalField()
            ),
            output_field=DecimalField())

    def hobby_rank_global(self, hobby: str = None, sort: str = 'net_score') -> QuerySet:
        if hobby:
            self.query = self.query & Q(posts__hobby__code_name=hobby)
        # annotations = {
        #     "net_score": ExpressionWrapper(Sum('posts__net_score') * Value(0.001), output_field=DecimalField())
        # }
        annotations = {
            "net_score": self.net_score()
        }
        dense_ranking = self.ranking('net_score')
        annotations['ranked'] = dense_ranking
        return Scoreboard.objects.filter(self.query).annotate(**annotations).distinct().order_by('ranked')

    def sort_by_love_global(self, hobby: str = None) -> QuerySet:
        if hobby:
            self.query = self.query & Q(posts__hobby__code_name=hobby)
        annotations = {
            "net_score": F('loves'),
            "ranked": self.ranking('net_score')
        }
        return Scoreboard.objects.filter(self.query).annotate(**annotations).distinct().order_by('ranked')

    def sort_by_views_global(self, hobby: str = None) -> QuerySet:
        if hobby:
            self.query = self.query & Q(posts__hobby__code_name=hobby)
        annotations = {
            "net_score": F('views'),
            "ranked": self.ranking('net_score')
        }
        return Scoreboard.objects.filter(self.query).annotate(**annotations).distinct().order_by('ranked')

    def find_users_in_queryset(self, queryset: QuerySet, user_string=None) -> QuerySet:
        account_str = user_string
        if not user_string:
            account_str = self.user.account_id
        return queryset.filter(Q(account__username__istartswith=account_str) |
                               Q(account__first_name__istartswith=account_str))

    def get_ranked_user(self, queryset: QuerySet, user_string: str) -> list:
        # TODO: Implement str match in persistant ranking
        scoreboards: QuerySet = self.find_users_in_queryset(queryset, user_string=user_string)
        return [self.serialize_hobby_rank(scoreboard)
                for scoreboard in sorted(scoreboards.iterator(),
                                         key=lambda scoreboard: (fuzz.ratio(user_string,
                                                                            scoreboard.account.username),
                                                                 fuzz.ratio(user_string,
                                                                            scoreboard.account.first_name)))]

    def serialize_hobby_rank(self, scoreboard: Scoreboard, hobby: str = None, sort: str = 'net_score') -> dict:
        return {
            "account": {
                "account_id": scoreboard.account.account_id,
                "username": scoreboard.account.username,
                "name": scoreboard.account.first_name + " " + scoreboard.account.last_name,
                "avatar": scoreboard.account.avatar
            },
            "score": scoreboard.net_score,
            "rank": scoreboard.ranked,
            "isSelf": 1 if self.user and scoreboard.account == self.user else 0,
            "sort": sort
        }
