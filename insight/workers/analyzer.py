"""
 Analyzer
 API for analyzing user activity in relation with hobbies
 API will receive signals from home such as create , view, love, share, comment or follow
 API can manage hobby_map and primary hobby of user for personalized experience
"""
import math
from insight.models import *
from insight.workers.interface import AnalyzerInterface
from celery import shared_task
from insight.utils import next_sunday, last_monday
from django.db.models import Q, QuerySet, ExpressionWrapper, F, DecimalField
from math import log


class Analyzer(AnalyzerInterface):
    counts = None

    @staticmethod
    def calculate_freshness_score(post: Post) -> float:
        diff = get_ist() - post.created_at
        return 2 * math.exp(-diff.days / 4) + 0.8

    @staticmethod
    def audit_post_counts(post: Post, after=None) -> dict:
        audits = {'love': post.loves.count(), 'view': post.views.count(), 'comment': post.comments.count(),
                  'share': post.shares.count(), 'up_vote': post.up_votes.count(), 'down_vote': post.down_votes.count()}
        return audits

    def manage_hobby_report(self, hobby: str, **reports) -> HobbyReport:
        hobbies: QuerySet = Hobby.objects.filter(code_name=hobby)
        if not hobbies.exists():
            return None
        hobby: Hobby = hobbies.first()
        hobby_reports: QuerySet = HobbyReport.objects.filter(Q(account=self.user) & Q(hobby=hobby))
        hobby_report: HobbyReport = None
        if hobby_reports.exists():
            hobby_report: HobbyReport = hobby_reports.first()
        else:
            hobby_report: HobbyReport = HobbyReport.objects.create(
                account=self.user, hobby=hobby
            )
        for key, value in reports.items():
            # only view,love, share supported
            hobby_report.__dict__[f'{key}s'] += value
        hobby_report.save()
        return hobby_report

    def score_post(self, counts: dict, for_comp=False) -> float:
        score: float = (self.WEIGHT_LOVE * counts['love']) + (self.WEIGHT_VIEW * counts['view']) + \
                       (self.WEIGHT_SHARE * counts['share'])
        if for_comp:
            score += (self.WEIGHT_UP_VOTE * counts['up_vote']) + (self.WEIGHT_DOWN_VOTE * counts['down_vote'])

        return score * 0.01

    def manage_score_post(self, post: Post, is_new: bool = False, after: datetime = None):
        post.freshness_score = self.calculate_freshness_score(post)
        post.score = self.score_post(self.audit_post_counts(post))
        post.net_score = post.freshness_score + post.score
        post.last_modified = get_ist()
        post.save()
        return post

    def manage_scoreboard(self, post: Post, created: bool = False, **actions):
        scoreboards: QuerySet = Scoreboard.objects.filter(Q(account=post.account) & Q(expires_on__gte=get_ist()) &
                                                          Q(created_at__lte=get_ist()))
        if not scoreboards.exists():
            scoreboard: Scoreboard = Scoreboard.objects.create(account=post.account, original_creation=get_ist(),
                                                               created_at=get_ist(),
                                                               expires_on=next_sunday(
                                                                   get_ist()) if get_ist().weekday() < 6 else get_ist())
        else:
            scoreboard: Scoreboard = scoreboards.first()
        scoreboard.posts.add(post)
        return scoreboard

    def user_activity(self, scoreboard: Scoreboard):
        posts: QuerySet = scoreboard.posts.all()
        if posts.exists():
            number: int = posts.count()
            avg_number_in_week: float = number / 4  # minimum required posts are 4 in a week
            if avg_number_in_week > 1:
                scoreboard.retention = log(avg_number_in_week)
                scoreboard.save()
        reports: QuerySet = HobbyReport.objects.select_related('hobby').filter(account=self.user) \
            .annotate(focus=ExpressionWrapper(
            F('views') + F('shares') + F('loves') + F('comments'), output_field=DecimalField()
        )).order_by('-focus')
        if reports.exists():
            report: HobbyReport = reports.first()
            self.user.primary_hobby = report.hobby.code_name
            self.user.save()

    @staticmethod
    @shared_task
    def background_task(user_id: str, post_id: str, created: bool = False, *count, **kwargs) -> None:
        users: QuerySet = Account.objects.filter(account_id=user_id)
        posts: QuerySet = Post.objects.filter(post_id=post_id)
        if users.count() == 0 or posts.count() == 0:
            return None
        user = users.first()
        post = posts.first()
        analyzer = Analyzer(user)
        if 'hobby' in kwargs and 'report' in kwargs:
            analyzer.manage_hobby_report(kwargs['hobby'], **kwargs['report'])
        actions = {}
        if 'home' in kwargs:
            actions = kwargs['home']
        analyzer.user_activity(analyzer.manage_scoreboard(post, **actions))
        return None

    def analyzer_create_post(self, post: Post):
        self.manage_hobby_report(post.hobby.code_name, post=1)
        self.manage_score_post(post, is_new=True)
        self.background_task.delay(self.user.account_id, post.post_id, created=True),

    def analyze_post_action(self, post: Post, for_test: bool = False, **actions):
        self.manage_score_post(post)
        self.background_task.delay(self.user.account_id, post.post_id, **actions)
