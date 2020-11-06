"""
Comments about a shit piece of program written just to workout in the current scene
@Author: Piyush Jaiswal
@email: iampiyushjaiswal103@gmail.com
@collaborator: Suyash Madhesia

Visit insight.algol.Leaderboard
"""
from django.db.models import Q, QuerySet
from insight.leaderboard.interface import *


class LeaderboardEngine(LeaderboardEngineInterface):

    def hobby_rank_global(self, hobby: str = None) -> QuerySet:
        expire_ques: Q = Q(expires_on__gte=get_ist())
        hobby_query = expire_ques & Q(hobby_score__has_key=hobby) if hobby else expire_ques
        scoreboard: Scoreboard = Scoreboard.objects.filter(hobby_query).select_related('account')\
            .order_by('net_score' if hobby is None else hobby)
        return scoreboard

    def find_users_in_queryset(self, queryset: QuerySet, user_string=None) -> QuerySet:
        if self.user and not user_string:
            return queryset.filter(account=self.user)
        return queryset.filter(Q(username__istartswith=user_string) | Q(first_name__istartswith=user_string) |
                               Q(last_name__istartswith=user_string))

    def sort_by_love(self, queryset: QuerySet) -> QuerySet:
        return queryset.order_by('loves')

    def sort_by_view(self, queryset: QuerySet) -> QuerySet:
        return queryset.order_by('views')

    @staticmethod
    def slice(queryset: QuerySet, *params):
        length = len(queryset)
        if length < 50:
            return queryset
        start, end = 0, length
        if len(params) == 2:
            start, end = params[0], params[1]
        elif len(params) == 1:
            end = params[0]
        return queryset[start: end]


    @staticmethod
    def serialize_hobby_rank(scoreboard: Scoreboard, rank: int, hobby: str = None) -> dict:
        return {
            "account": {
                "account_id": scoreboard.account.account_id,
                "username": scoreboard.account.username,
                "name": scoreboard.account.first_name + " " + scoreboard.account.last_name,
                "avatar": scoreboard.account.avatar
            },
            "hobby_score": scoreboard.hobby_scores[hobby] if hobby else  scoreboard.net_score,
            "score": scoreboard.net_score,
            "rank": rank
        }

