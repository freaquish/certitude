"""
 Analyzer
 API for analyzing user activity in relation with hobbies
 API will receive signals from actions such as create , view, love, share, comment or follow
 API can manage hobby_map and primary hobby of user for personalized experience
"""
from datetime import timedelta
from insight.models import Hobby, Post, Account, get_ist, Scoreboard
from django.db.models import Q


WEIGHT_VIEW: float = 0.20
WEIGHT_LOVE: float = 0.50
WEIGHT_COMMENT: float = 0.20
WEIGHT_SAVE: float = 0.80
WEIGHT_SHARE: float = 0.85
WEIGHT_CREATE: float = 0.90
WEIGHT_FOLLOWING: float = 0.45
WEIGHT_FRIEND: float = 0.85


class Analyzer:

    def __init__(self, user: Account):
        self.user = user

    """
      Inject hobby into hobby map increasing weight 
      update primary_hobby and primary_hobby_weight
    """

    def max_in_map(self):
        maximum_hobby = ''
        maximum_weight = 0.0
        for key in self.user.hobby_map.keys():
            if self.user.hobby_map[key] > maximum_weight:
                maximum = key
        return maximum

    def analyze(self, post: Post, weight: float):
        post_hobby_code_name = post.hobby.code_name
        post_hobby_weight = post.hobby.weight

        if post_hobby_code_name in self.user.hobby_map:
            self.user.hobby_map[post_hobby_code_name] += weight
        else:
            self.user.hobby_map[post_hobby_code_name] = weight

        if not self.user.primary_hobby:
            self.user.primary_hobby = post_hobby_code_name
            self.user.primary_weight = post_hobby_weight
        self.user.primary_hobby = self.max_in_map()
        self.user.save()

    def analyze_create_post(self, post: Post):
        self.analyze(post, WEIGHT_CREATE)
        weight = WEIGHT_CREATE
        scoreboards = Scoreboard.objects.filter(
            Q(account=post.account) & Q(expires_on__gte=get_ist()))
        if not scoreboards:
            scoreboard: Scoreboard = Scoreboard.objects.create(account=post.account, created_at=get_ist(),
                                                               expires_on=get_ist() + timedelta(days=7))
        else:
            scoreboard: Scoreboard = scoreboards.first()
        if post.hobby.code_name in scoreboard.hobby_scores:
            scoreboard.hobby_scores[post.hobby.code_name] += weight
        else:
            scoreboard.hobby_scores[post.hobby.code_name] = weight
        net_score: float = 0.0
        for index, (hobby, score) in enumerate(scoreboard.hobby_scores.items()):
            net_score += score
        scoreboard.net_score = net_score
        scoreboard.save()

    def analyze_post_after_scoring(self, post: Post):
        scoreboard = Scoreboard.objects.filter()
