from insight.models import Account, RankReport, Competition, get_ist
from django.db.models import QuerySet
from insight.competitions.main import CompetitionManager


class CompetitionLeaderboardSerializer:

    def __init__(self, reports: QuerySet, user: Account = None):
        self.user: Account = user
        self.reports: QuerySet = reports

    def _serialize(self, report: RankReport):
        if not hasattr(report, "ranked"):
            return None
        trend = 0
        if len(report.tree) > 1:
            trend = 1 if (report.tree[-1] - report.tree[-2]) > 0 else -1
        return {
            "avatar": report.user.avatar,
            "name": report.user.first_name + " " + report.user.last_name,
            "username": report.user.username,
            "score": report.current_score,
            "rank": report.ranked,
            "trend": trend,
            "isSelf": 1 if self.user is not None and report.user_id == self.user.account_id else 0
        }

    def render(self):
        return [self._serialize(report) for report in self.reports.iterator()]


class CompetitionSearchSerializer:

    def __init__(self, competitions: QuerySet, user: Account = None):
        self.competitions: QuerySet = competitions
        self.user: Account = user

    def _serializer(self, competition: Competition):
        return {
            "key": competition.key,
            "tag": f"#{competition.tag}",
            "name": competition.name,
            "avatar": competition.images[0],
            "is_host": 1 if self.user is not None and competition.user_host_id == self.user.account_id else 0,
            "post_count": competition.post_count,
            "participated":  1 if hasattr(competition, "participated") and competition.participated >= 1 else 0,
            "is_live": 1 if competition.result >= get_ist() else 0,
            "is_accepting_participation": 1 if competition.end >= get_ist() else 0,
            "start": competition.strftime(CompetitionManager.format()),
            "end": competition.strftime(CompetitionManager.format()),
            "result": competition.strftime(CompetitionManager.format())
        }

    def render(self):
        return [self._serializer(competition) for competition in self.competitions.iterator()]
