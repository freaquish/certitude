"""
 Analyzer
 API for analyzing user activity in relation with hobbies
 API will receive signals from actions such as create , view, love, share, comment or follow
 API can manage hobby_map and primary hobby of user for personalized experience
"""
from datetime import timedelta
from insight.models import Post, Account, get_ist, Scoreboard, ScorePost
from django.db.models import Q, QuerySet
from math import log

WEIGHT_CREATE: float = 0.80


class Analyzer:

    def __init__(self, user: Account):
        self.user = user

    """
      Inject hobby into hobby map increasing weight 
      update primary_hobby and primary_hobby_weight
    """

    def max_in_map(self):
        maximum_weight = 0.0
        keys = self.user.hobby_map.keys()
        maximum = keys[0]
        for key in keys:
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
        self.analyze_scoreboard(post)

    @staticmethod
    def user_activity(scoreboard: Scoreboard):
        posts: QuerySet = Post.objects.filter(
            Q(created_at__gte=scoreboard.created_at) & Q(created_at__lte=scoreboard.expires_on)
        )
        if posts:
            number: int = len(posts)
            avg_number_in_week: float = number / 4  # minimum required posts are 4 in a week
            if avg_number_in_week > 1:
                scoreboard.retention = log(avg_number_in_week)
                scoreboard.net_score += scoreboard.retention
                scoreboard.save()

    def analyze_scoreboard(self, post: Post):
        scoreboards = Scoreboard.objects.filter(
            Q(account=post.account) & Q(expires_on__gte=get_ist())
        )
        if not scoreboards:
            scoreboard: Scoreboard = Scoreboard.objects.create(account=post.account, created_at=get_ist(),
                                                               expires_on=get_ist() + timedelta(days=7))
        else:
            scoreboard: Scoreboard = scoreboards.first()
        score_posts: QuerySet = ScorePost.objects.filter(post=post)
        if score_posts:
            score_post: ScorePost = score_posts.first()
            if scoreboard.hobby_scores[post.hobby.code_name]:
                scoreboard.hobby_scores[post.hobby.code_name] += score_post.net_score
            else:
                scoreboard.hobby_scores[post.hobby.code_name] = score_post.net_score
        net_score: float = 0.0
        for hobby, score in scoreboard.hobby_scores.items():
            net_score += score
        scoreboard.net_score = net_score
        scoreboard.save()
        self.user_activity(scoreboard)
