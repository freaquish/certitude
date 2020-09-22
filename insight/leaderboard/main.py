"""
Comments about a shit piece of program written just to workout in the current scene
@Author: Piyush Jaiswal
@email: iampiyushjaisw al103@gmail.com
@collaborator: Suyash Madhesia

Visit insight.algol.Leaderboard
"""
from insight.utils import get_ist, get_ist_date, get_ist_time
from celery import shared_task
from django.db.models import Q, QuerySet
from datetime import timedelta
from insight.models import *


class LeaderBoardEngine:
    """
    Implmentation of Leaderboard used for serving hobby-wise user rank, weekly-user-rank, community-rank, community-user-rank
    """
    def __init__(self, **kwargs):
        if 'hobby' in kwargs:
            self.hobby = kwargs.get('hobby')
        if 'user' in kwargs:
            self.user = kwargs.get('user')

    @staticmethod
    def serialize_hobby_rank(scoreboard: Scoreboard, hobby: str, rank: int):
        return {
            "account": {
                "account_id": scoreboard.account.account_id,
                "username": scoreboard.account.username,
                "name": f'{scoreboard.account.first_name} {scoreboard.account.last_name}',
                "avatar": scoreboard.account.avatar
            },
            "hobby": hobby,
            "score": scoreboard.hobby_scores[hobby],
            "rank": rank
        }

    def hobby_rank_global(self):
        # user rank in each hobby
        scoreboards = Scoreboard.objects.filter(Q(hobby_scores__has_key=self.hobby) & Q(
            Q(created_at__lte=get_ist_date()) & Q(expires_on__gte=get_ist_date())))
        if scoreboards:
            scoreboards = sorted(scoreboards, key=lambda scoreboard: scoreboard.hobby_scores[self.hobby])
            return [self.serialize_hobby_rank(scoreboard, self.hobby, index + 1) for index, scoreboard in
                    enumerate(scoreboards)]
        else:
            return []

    @staticmethod
    def post_rank(code_name: str):
        # post rank in particular hobby
        posts = Post.objects.filter(Q(last_activity_on__gte=get_ist() - timedelta(days=7)) &
                                    Q(hobby__code_name=code_name)).order_by('score')
        for index, post in enumerate(posts):
            post.rank = index
            post.save()
            yield post

    @shared_task
    def weekly_rank_user(account_id: str):
        # weekly ranking of user, assigns rank-badge
        accounts = Account.objects.filter(account_id=account_id)
        if not accounts:
            return None
        account: Account = accounts.first()
        scoreboards = Scoreboard.objects.filter(Q(account=account) & Q(expires_on=get_ist_date())).order_by('net_score')
        length = len(scoreboards)
        hobbies = Hobby.objects.all()
        if scoreboards:
            # scoreboards = sorted(scoreboards, key=lambda scoreboard: scoreboard.net_score)
            for index in range(len(scoreboards)):
                scoreboards[index].rank = index + 1
                rank_badge = RankBadge.objects.create(
                    competition_name='Weekly Competition', date_field=scoreboards[index].expires_on,
                    hobby=Hobby.objects.get(code_name=account.primary_hobby), account=account,
                    total=length, rank=index + 1, score=scoreboards[index].net_score
                )
                scoreboards[index].save()
            return None

    @staticmethod
    def serialize_rank_badge(badge: RankBadge):
        return {
            "competition_name": badge.competition_name,
            "date": badge.date_field.strftime('%d-%M-%Y'),
            "total": badge.total,
            "rank": badge.rank,
            "score": badge.score,
            "hobby": badge.hobby
        }

    def fetch_global_user_rank(self):
        # this method fetches rank badge of given user
        # this week if |created_at| <----> |expires_on|
        # if n : given date, is gte created_at and lte expires_on
        rank_badges = RankBadge.objects.filter(account=self.user).order_by('-date_field')
        if rank_badges:
            return [self.serialize_rank_badge(badge) for badge in rank_badges]
        return []
