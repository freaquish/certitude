from insight import models
from django.db.models import QuerySet, Q


class TrendsInterface:

    def __init__(self, *account):
        if account:
            self.account: models.Account = account[0]

    def extract_trending_in_hobby_user(self, *hobbies) -> Q:
        """
        Returns Q encoded query using the argument query to filter provided hobbies
        """
        pass

    def extract_queryset(self, *query: Q) -> QuerySet:
        """
        Returns QuerySet with annotation of current scores
        score calculation formula will be used to calculate score for sorting
        Formula: 2exp(-time/4) + 0.001(W(l)*love + W(v)+view + W(s)*share)

        TODO: Personalising posts aggregation according to hobby report of user
        """
        pass
