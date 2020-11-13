from insight import models
from django.db.models import QuerySet, Q


class TrendsInterface:

    def __init__(self, *account):
        if account:
            self.account: models.Account = account[0]

    def extract_post_trending_query(self) -> Q:
        """
        Returns Q encoded query for extracting trending queries

        The Query will be used to extract all trending posts with highest score
        by calling Score Post using net_score
        """
        pass

    def extract_trending_in_hobby(self, query: Q, *hobbies) -> Q:
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
