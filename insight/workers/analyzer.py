"""
 Analyzer
 API for analyzing user activity in relation with hobbies
 API will receive signals from actions such as create , view, love, share, comment or follow
 API can manage hobby_map and primary hobby of user for personalized experience
"""
import math
from insight.models import *
from insight.workers.interface import AnalyzerInterface
from celery import shared_task
from insight.utils import next_sunday
from django.db.models import Q, QuerySet
from math import log


class Analyzer(AnalyzerInterface):
    counts = None

    @staticmethod
    def calculate_freshness_score(post: Post) -> float:
        diff = get_ist() - post.created_at
        return math.exp(-diff.days)

    @staticmethod
    def audit_post_counts(post: Post, after=None) -> dict:
        # TODO: Heavy Optimization is required when
        if after:
            action_stores: QuerySet = ActionStore.objects.filter(Q(post_id=post.post_id) & Q(viewed_at__gte=after)
                                                                 & Q(viewed=True))
        else:
            action_stores: QuerySet = ActionStore.objects.filter(Q(post_id=post.post_id) & Q(viewed=True))
        audits = {'love': 0, 'view': 0, 'comment': 0, 'share': 0, 'up_vote': 0, 'down_vote': 0}
        for action_store in action_stores:
            audits['love'] += 1 if action_store.loved else 0
            audits['view'] += 1
            audits['comment'] += 1 if action_store.commented else 0
            audits['share'] += 1 if action_store.shared else 0
            audits['up_vote'] += 1 if action_store.up_voted else 0
            audits['down_vote'] += 1 if action_store.down_voted else 0

        return audits

    def manage_hobby_report(self, hobby: str, **reports) -> HobbyReport:
        hobbies: QuerySet = Hobby.objects.filter(code_name=hobby)
        if not hobbies:
            return None
        hobby: Hobby = hobbies.first()
        hobby_report, created = HobbyReport.objects.get_or_create(account=self.user, hobby=hobby)
        for key, value in reports.items():
            hobby_report.__dict__[key] += value
        hobby_report.save()
        return hobby_report

    def score_post(self, counts: dict, for_comp=False) -> float:
        score: float = (self.WEIGHT_LOVE * counts['love']) + (self.WEIGHT_VIEW * counts['view']) + \
                       (self.WEIGHT_SHARE * counts['share'])
        if for_comp:
            score += (self.WEIGHT_UP_VOTE * counts['up_vote']) + (self.WEIGHT_DOWN_VOTE * counts['down_vote'])

        return score

    def manage_score_post(self, post: Post, is_new: bool = False, after: datetime = None):
        if is_new:
            score_post = ScorePost.objects.create(post=post, created_at=get_ist(), last_modified=get_ist())
        else:
            score_post, created = ScorePost.objects.get_or_create(post=post)
        score_post.freshness_score = self.calculate_freshness_score(post)
        if self.counts is None:
            self.counts = self.audit_post_counts(post, after)
        score_post.score = self.score_post(self.counts)
        score_post.net_score = score_post.freshness_score * score_post.score
        score_post.last_modified = get_ist()
        score_post.save()
        return score_post

    def manage_scoreboard(self, post: Post, created: bool = False, **actions):
        scoreboards: QuerySet = Scoreboard.objects.filter(Q(account=post.account) & Q(expires_on__gte=get_ist()))\
            .select_related('account')
        if not scoreboards:
            scoreboard: Scoreboard = Scoreboard.objects.create(account=post.account, created_at=get_ist(),
                                                               expires_on=next_sunday(get_ist()))
        else:
            scoreboard: Scoreboard = scoreboards.first()
        scores = scoreboard.hobby_scores
        score_posts = ScorePost.objects.filter(post=post)
        if not score_posts:
            return None
        score_post: ScorePost = score_posts.first()
        if not post.hobby.code_name in scores:
            scores[post.hobby.code_name] = 0
        scores[post.hobby.code_name] += float(score_post.net_score)
        if created:
            scores = {k: float(v) + self.WEIGHT_CREATE for k, v in scores.items()}
        if len(actions):
            for action, value in actions.items():
                scoreboard.__dict__[f'{action}s'] += value
        self.user.hobby_map = scores
        self.user.primary_hobby = max(scores, key=lambda hobby: scores[hobby])
        self.user.save()
        scoreboard.hobby_scores = scores
        scoreboard.net_score = sum([points for points in scoreboard.hobby_scores.values()])
        scoreboard.save()
        return scoreboard

    def user_activity(self, scoreboard: Scoreboard):
        posts: QuerySet = Post.objects.filter(Q(account=scoreboard.account) &
            Q(created_at__gte=scoreboard.created_at) & Q(created_at__lte=scoreboard.expires_on)
        )
        if posts:
            number: int = len(posts)
            avg_number_in_week: float = number / 4  # minimum required posts are 4 in a week
            if avg_number_in_week > 1:
                scoreboard.retention = log(avg_number_in_week)
                scoreboard.net_score += scoreboard.retention
                scoreboard.save()

    @staticmethod
    @shared_task
    def background_task(user_id: str, post_id: str, created: bool = False, *count, **kwargs) -> None:
        users: QuerySet = Account.objects.filter(account_id=user_id)
        posts: QuerySet = Post.objects.filter(post_id=post_id)
        if len(users) == 0 or len(posts) == 0 :
            return None
        user = users.first()
        post = posts.first()
        analyzer = Analyzer(user)
        if 'hobby' in kwargs and 'report' in kwargs:
            analyzer.manage_hobby_report(kwargs['hobby'], **kwargs['report'])
        actions = {}
        if 'actions' in kwargs:
            actions = kwargs['actions']
        analyzer.user_activity(analyzer.manage_scoreboard(post, **actions))
        return None

    def analyzer_create_post(self, post: Post):
        self.manage_hobby_report(post.hobby.code_name, posts=1)
        self.manage_score_post(post, is_new=True)
        self.background_task.delay(self.user.account_id, post.post_id, created=True),

    def analyze_post_action(self, post: Post, for_test: bool = False, **actions):
        self.manage_score_post(post)
        if for_test:
            self.user_activity(self.manage_scoreboard(post, **actions))
            return None
        self.background_task.delay(self.user.account_id, post.post_id, **actions)
