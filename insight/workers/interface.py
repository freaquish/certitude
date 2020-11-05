from insight import models
from django.db.models import QuerySet, Q


class PostCreationInterface:
    def __init__(self, user: models.Account, **kwargs):
        self.user: models.Account = user
        self.kwargs = kwargs

    """
    Catch signal for post creation
    """

    def catch(self):
        pass

    """
    Return keys from kwargs for easy access done to avoid typing `self.kwargs[key]`
    """

    def map(self, key: str):
        if key in self.kwargs:
            return self.kwargs.get(key)
        return None

    """
    Render all dat passed through http for making it compatible
    creation of action_count int to bool conversion and data for direct object creation
    """

    def render_data(self) -> dict:
        pass

    """
    Creates Post using render_data
    """

    def create_post(self):
        pass

    """
    Create tags not present in database retaining their symbols i.e # or @
    Data Packets contains atags and hastags which are used to create only tags not present in db
    """

    def create_tag(self):
        pass

    """
    Function responsible for calling all after math functions of post creation
    such as create_tag, attach_community, creating score_post and facilitating HobbyReport
    """

    def after_creation(self):
        pass

    """
    Attach post to their respective community
    if @all @hobby_name in tag then post will be attached to all/all hobby community user ever joined
    by creating community post
    """

    def attach_to_community(self):
        pass

    """
    Attach post to tagged competition after checking eligibility
    such as uniqueness, maximum_post_per_user
    """

    def attach_to_competition(self):
        pass


class AnalyzerInterface:
    WEIGHT_CREATE: float = 0.80
    WEIGHT_VIEW: float = 0.15
    WEIGHT_LOVE: float = 0.30
    WEIGHT_SHARE: float = 0.5
    WEIGHT_COMMENT: float = 0.05
    WEIGHT_UP_VOTE: float = 1.25
    WEIGHT_DOWN_VOTE: float = -1.45

    def __init__(self, user: models.Account):
        self.user: models.Account = user

    """
    Create Hobby Report if one such doesn't exist or return the existing,
    the main motivation of hobby report
    is to maintain hobby score of each user to predict interest.
    Weightage are distributed emotionally
    """

    def manage_hobby_report(self, hobby: str, **reports) -> models.HobbyReport:
        pass

    """
    Score Post is created after post creation immediately
    Function will calculate freshness_score and net_score on the basis of action_stores
    of the post just actioned by user
    """

    def manage_score_post(self, post: models.Post) -> models.ScorePost:
        pass

    """
    manage Scoreboard get or create scoreboard for user valid for a week
    calculates scores using score_posts and updates it all
    """

    def manage_scoreboard(self, post: models.Post, created: bool = False) -> models.Scoreboard:
        pass

    """
    Calculates freshness_score using formula e^(-x) were important param is days
    but important problem is if any post is significantly old but has high popularity 
    then it might screened at last
    
    """

    @staticmethod
    def calculate_freshness_score(post: models.Post) -> float:
        pass

    """
    Audits Action store and returns total counts
    if after is None then audit all stores
    else audit store gte after
    """

    @staticmethod
    def audit_post_counts(post: models.Post, after=None) -> dict:
        pass

    """
    Score Post on the basis of counts using the weights
    (1 + [W(l)*n(l) + W(v)n(v) + W(sh)n(sh) + W(uv)n(uv) + W(dv)n(dv)])
    """

    def score_post(self, counts: dict, for_comp=False) -> float:
        pass

    """
    Used to run task in background on celery
    current list of task qualified for bg are
    manage_scoreboard, user_activity
    """

    @staticmethod
    def background_task(user_id: str, *count) -> None:
        pass

    """
    Function important for calculating retention per week 
    """

    def user_activity(self, scoreboard: models.Scoreboard):
        pass

    """
    After post creations call hobby_report with create and weight and then call 
    manage_score_post call background_task
    """

    def analyzer_create_post(self, post: models.Post):
        pass

    """
    Called after post action fire, call manage_score_post, manage_hobby_report
    actions will contain action such as view/love/share and 1 or -1
    then background_task
    """
    def analyze_post_action(self, post: models.Post, **actions):
        pass


class DataLogInterface:
    def __init__(self, user: models.Account):
        self.user: models.Account = user

    """
    Log error whenever any programs fails headers containing arguments and requests
    """
    def log_error(self, request_header: dict, process: str, **extra):
        pass
