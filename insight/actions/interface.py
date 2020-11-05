from insight import models
from django.db.models import QuerySet, Q


class TrendsInterface:

    def __init__(self, *account):
        if account:
            self.account: models.Account = account[0]

    """
    Extracting Query ScorePost with associated hobby scoring
    Scoring algorithm will annotate interface_score which will be used
    to order
    """

    def extract_top_hobby_post(self, hobby_codes: dict, queryset: QuerySet = None) -> Q:
        pass

    """
    Annotate queryset with interface formula which is
    (e^(hobby_weight_user))e^(-freshness_score)(1 + ([score]) +  follower_weight) 
    + WeightFollower
    """

    def annotate_interface_formula(self, queryset: QuerySet, follower_weight: float = 0.0) -> QuerySet:
        pass

    """
    Manipulate interface_score using nearest_hobby 
    nearest_hobby is |primary_hobby_weight * hits - post_hobby * hits(nearest_hobby_in_map)|/10
    """
    def nearest_hobby_scoring(self, queryset: QuerySet) -> QuerySet:
        pass

    """
    Check if models inside queryset are same then join them using '|' operator
    """

    @staticmethod
    def join_queryset(*queryset_list) -> QuerySet:
        model_class = None
        q_set: QuerySet = None
        for queryset in queryset_list:
            if len(queryset) > 0:
                if model_class is None:
                    model_class = queryset.first().__class__
                elif model_class == queryset.first().__class__:
                    if q_set:
                        q_set = q_set | queryset
                    else:
                        q_set = queryset
        if q_set:
            return q_set
        return QuerySet

    """
    Extract all following list find all the ScorePosts and send for annotation
    """

    def extract_follower_post(self) -> Q:
        pass

    """
    Extract top performing post independent of hobbies 
    """

    def extract_top_ranked_for_unknown(self) -> Q:
        pass

    """
    Collect all required posts, annotate them, sort them
    """

    def render_posts(self) -> QuerySet:
        pass
