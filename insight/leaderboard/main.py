"""
Comments about a shit piece of program written just to workout in the current scene
@Author: Piyush Jaiswal
@email: iampiyushjaiswal103@gmail.com
@collaborator: Suyash Madhesia

Visit insight.algol.Leaderboard
"""
from django.db.models import Q, Window, F, Count, Sum
from django.db.models.functions import DenseRank
from fuzzywuzzy import fuzz
from insight.leaderboard.interface import *


class LeaderboardEngine(LeaderboardEngineInterface):

    def hobby_rank_global(self, hobby: str = None, sort: str = 'net_score') -> QuerySet:
        query = Q(expires_on__gte=get_ist().date()) & Q(created_at__lte=get_ist().date())
        if hobby:
            query = query & Q(posts__hobby__code_name=hobby)
        annotations = {
            "views": Count('posts__views', distinct=True),
            "loves": Count('posts__loves', distinct=True),
            "shares": Count('posts__shares', distinct=True),
            "up_votes": Count('posts__up_votes', distinct=True),
            "down_votes": Count('posts__down_votes', distinct=True),
            "net_score": Sum('posts__net_score'),
        }
        dense_ranking = Window(
            expression=DenseRank(),
            order_by=F(sort).desc()
        )
        annotations['ranked'] = dense_ranking
        return Scoreboard.objects.filter(query).annotate(**annotations).distinct()

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

    def serialize_hobby_rank(self, scoreboard: Scoreboard, hobby: str = None) -> dict:
        return {
            "account": {
                "account_id": scoreboard.account.account_id,
                "username": scoreboard.account.username,
                "name": scoreboard.account.first_name + " " + scoreboard.account.last_name,
                "avatar": scoreboard.account.avatar
            },
            "score": scoreboard.net_score,
            "rank": scoreboard.ranked,
            "isSelf": 1 if self.user and scoreboard.account == self.user else 0
        }
