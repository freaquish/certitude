from insight.models import *
from django.db.models import QuerySet


class LeaderboardEngineInterface:

    def __init__(self, **kwargs):
        if 'user' in kwargs:
            self.user = kwargs['user']

    """
    Fetch Global in Given Hobby, using scoreboard in given week
    Fetch Scoreboard using lookup `expires_on__get=today` & `hobby_scores_has_key=code_name`
    it returns queryset
    """

    def hobby_rank_global(self, hobby: str = None, sort: str = 'net_score') -> QuerySet:
        pass

    """
    Serialize hobby rank and insert rank, encoding format is JSON
    """

    @staticmethod
    def serialize_hobby_rank(scoreboard: Scoreboard, rank: int, hobby: str = None) -> dict:
        pass

    """
    Search users the scoreboard using text search filter
    returns the queryset, if user_string is none than returns the only queryset
    containing instance users score in the hobby
    """

    def find_users_in_queryset(self,queryset: QuerySet, user_string=None) -> QuerySet:
        pass

