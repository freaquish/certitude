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
            audits['up_vote'] += 1 if action_store.up_vote else 0
            audits['down_vote'] += 1 if action_store.down_vote else 0

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
        return 1 + score

    def manage_score_post(self, post: Post, is_new: bool = False, after: bool = False):
        if is_new:
            score_post = ScorePost.objects.create(post=post, created=get_ist(), last_modified=get_ist())
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

    def manage_scoreboard(self, post: Post, created: bool = False):
        scoreboards: QuerySet = Scoreboard.objects.filter(Q(account=self.user) & Q(expores_on__gte=get_ist()))
        if not scoreboards:
            scoreboard: Scoreboard = Scoreboard.objects.create(account=self.user, creates_at=get_ist(),
                                                               expires_on=get_ist() + timedelta(days=7))
        else:
            scoreboard: Scoreboard = scoreboards.first()
        hobby_reports: QuerySet = HobbyReport.objects.filter(account=self.user)
        scores = {}
        for report in hobby_reports:
            scores[report.hobby.code_name] = self.score_post({'love': report.loves, 'view': report.views,
                                                              'share': report.share})
        if created:
            scores = {k: v+self.WEIGHT_CREATE for k, v in scores.items()}
        self.user.hobby_map = scores
        self.user.primary_hobby = max(scores, key=lambda hobby: scores[hobby])
        self.user.save()
        scoreboard.hobby_scores = scores
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
    def background_task(user_id: str, *count, **kwargs) -> None:
        user: Account = Account.objects.get(pk=user_id)
        analyzer = Analyzer(user)
        if 'hobby' in kwargs and 'report' in kwargs:
            analyzer.manage_hobby_report(kwargs['hobby'], **kwargs['report'])
        analyzer.user_activity(analyzer.manage_scoreboard())
        return None

    def analyzer_create_post(self, post: Post):
        self.manage_hobby_report(post.hobby.code_name, posts=1)
        self.manage_score_post(post)
        self.background_task.delay(self.user.account_id)

    def analyze_post_action(self, post: Post, **actions):
        pass
