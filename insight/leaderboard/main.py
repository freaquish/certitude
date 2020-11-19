"""
Comments about a shit piece of program written just to workout in the current scene
@Author: Piyush Jaiswal
@email: iampiyushjaiswal103@gmail.com
@collaborator: Suyash Madhesia

Visit insight.algol.Leaderboard
"""
from django.db.models import Q, QuerySet, Window, F
from fuzzywuzzy import fuzz
from insight.utils import next_sunday, last_monday
from django.contrib.postgres.fields.jsonb import KeyTextTransform
from django.db.models.functions import DenseRank
from insight.leaderboard.interface import *


class LeaderboardEngine(LeaderboardEngineInterface):

    def hobby_rank_global(self, hobby: str = None, sort: str = 'net_score') -> QuerySet:
        query = Q(expires_on__gte=get_ist().date()) & Q(created_at__lte=get_ist().date())
        ordering = sort
        dense_ranking = Window(
            expression=DenseRank(),
            order_by=F('scored').desc()
        )
        annotate = {'scored': F('net_score'), 'ranked': dense_ranking}
        if hobby:
            query = query & Q(hobby_scores__has_key=hobby)
            ordering = f'hobby_scores__{hobby}' if sort == 'net_score' else sort
            annotate['scored'] = KeyTextTransform(hobby, 'hobby_scores')
        return Scoreboard.objects.filter(query).annotate(**annotate)

    def find_users_in_queryset(self, queryset: QuerySet, user_string=None) -> QuerySet:
        account_str = user_string
        if not user_string:
            account_str = self.user.account_id
        return queryset.filter(Q(account__username__istartswith=account_str) |
                               Q(account__first_name__istartswith=account_str))

    def get_ranked_user(self, queryset: QuerySet, user_string: str) -> list:
        scoreboards: QuerySet = self.find_users_in_queryset(queryset, user_string=user_string)
        print(scoreboards.values_list('account', 'ranked', 'scored'))
        return [self.serialize_hobby_rank(scoreboard, index)
                for index, scoreboard in enumerate(sorted(scoreboards,
                                                          key=lambda scoreboard: (fuzz.ratio(user_string , scoreboard.account.username), fuzz.ratio(user_string,scoreboard.account.first_name))))]

    def serialize_hobby_rank(self, scoreboard: Scoreboard, rank: int, hobby: str = None) -> dict:
        return {
            "account": {
                "account_id": scoreboard.account.account_id,
                "username": scoreboard.account.username,
                "name": scoreboard.account.first_name + " " + scoreboard.account.last_name,
                "avatar": scoreboard.account.avatar
            },
            "score": scoreboard.scored,
            "rank": scoreboard.ranked,
            "isSelf": 1 if self.user and scoreboard.account == self.user else 0
        }
