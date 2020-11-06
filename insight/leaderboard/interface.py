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

    def hobby_rank_global(self, hobby: str = None) -> QuerySet:
        pass

    """
    Serialize hobby rank and insert rank, encoding format is JSON
    """

    @staticmethod
    def serialize_hobby_rank(scoreboard: Scoreboard, rank: int, hobby: str = None) -> dict:
        pass

    """
    Search users within the given queryset using text search filter
    returns the queryset, if user_string is none than returns the only queryset
    containing instance users score in the hobby
    """

    def find_users_in_queryset(self, queryset: QuerySet, user_string=None) -> QuerySet:
        pass

    """
    Sort given queryset with most love
    """

    def sort_by_love(self, queryset: QuerySet) -> QuerySet:
        pass

    """
    Sort given queryset with most views
    """

    def sort_by_view(self, queryset: QuerySet) -> QuerySet:
        pass
