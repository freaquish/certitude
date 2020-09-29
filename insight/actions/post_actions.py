from celery import shared_task
from insight.models import *
import json
from datetime import timedelta
from django.db.models import Q, QuerySet
from insight.manager.analyzer import Analyzer
from insight.leaderboard.main import LeaderBoardEngine
from insight.utils import get_ist

"""
 Micro Actions are set of actions included in the post, generally used for expression about the post by the viewer.
 The Actions are View, Love, UnLove, Share, Save, UnSave, Comment
 View is ought to be first action, fired instantly when intersection of post with viewport is 1.
 Save, UnSave and Comment are only allowed to Registered users.
 Every Action will create or update an ActionStore with unique pair of post_id and account_id
 The meta score will be updated instantly after the action is fired.
"""

WEIGHT_VIEW: float = 0.20
WEIGHT_LOVE: float = 0.50
WEIGHT_COMMENT: float = 0.65
WEIGHT_SAVE: float = 0.80
WEIGHT_SHARE: float = 0.95
WEIGHT_FOLLOWER: float = 0.30
WEIGHT_FOLLOWING: float = 0.45
WEIGHT_FRIEND: float = 0.85


class MicroActions:

    def __init__(self, post_id: str, account: Account = None, anonymous=False):
        self.post = Post.objects.filter(post_id=post_id).first()
        if account:
            self.user = account
            self.analyzer = Analyzer(self.user)
        else:
            self.user = None
        self.anonymous = anonymous

    @staticmethod
    @shared_task
    def score_post(post_id, user_id, weight=0.0):
        # user = Account.objects.get(pk=user_id)
        posts = Post.objects.filter(post_id=post_id)
        if not posts:
            return None
        post = posts.first()
        comment_score: float = 1.0 + \
                               float(WEIGHT_COMMENT * post.action_count['comment'])
        love_score: float = 1.0 + \
                            float(WEIGHT_LOVE * post.action_count['love'])
        share_score: float = 1.0 + \
                             float(WEIGHT_SHARE * post.action_count['share'])
        save_score: float = 1.0 + \
                            float(WEIGHT_SAVE * post.action_count['save'])
        view_score: float = 1.0 + \
                            float(WEIGHT_VIEW * post.action_count['view'])
        score = 1 + (comment_score * love_score * share_score * save_score * view_score)
        post.score = score
        if not weight == WEIGHT_VIEW:
            post.last_activity_on = get_ist()
        post.save()
        leaderboard = LeaderBoardEngine.post_rank(post.hobby)
        scoreboards = Scoreboard.objects.filter(Q(account=post.account) & Q(expires_on__gte=get_ist()))
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

    def commit_action(self, **action):

        if self.user:
            action_store, created = ActionStore.objects.get_or_create(
                account_id=self.user.account_id, post_id=self.post.post_id)
            # print(action_store)
            if 'viewed' in action and action_store.viewed:
                return False
            else:
                action_store.update(**action)
        return True

    def commented(self, value):
        if self.user:
            comment = UserPostComment.objects.create(post_id=self.post.post_id, account=self.user, created_at=get_ist(), comment=value)
            return self.commit_action(commented=True)

    """
      Follow user function will receive two arguments
      followed: the account to be followed
      user: the account requesting to follow
      Steps:
         1. Check if user.following column is not None, if yes then assign a list
         2. Check if followed is not present in user.following, if yes then [return None] else Step 3
         3. Append followed in user.following
         4. Increase the following count of user and follower count of followed, save
         5. [return None]
    """

    @staticmethod
    def follow_user(followed: Account, user: Account):
        # print(f"{followed.username},{user.username},'follow'")
        if not user.following:
            user.following = []
        if followed.account_id in user.following:
            return None
        user.following.append(followed.account_id)
        user.following_count = len(user.following)
        if followed.follower_count:
            followed.follower_count += 1
        else:
            followed.follower_count = 1
        user.save()
        followed.save()
        return None

    """
     Un-Follow User(followed,user)
     Steps:
        1. Check if followed is in user.following, if no [return None] else Step 2
        2. remove followed from user.following
        3. update user.following_count and followed.follower_count, save
        4. [return None]
    """

    @staticmethod
    def un_follow_user(followed: Account, user: Account):
        # print(f"{followed.username},{user.username},'un_follow'")
        if not followed.account_id in user.following:
            return None
        user.following.remove(followed.account_id)
        user.following_count = len(user.following)
        if followed.follower > 1:
            followed.follower -= 1
        else:
            followed.follower = 0
        user.save()
        followed.save()
        return None

    def increment(self, key, weight):
        self.post.action_count[key] += 1
        self.analyzer.analyze(self.post, weight)

    def decrement(self, key, weight):
        if self.post.action_count[key] > 0:
            self.post.action_count[key] -= 1
        else:
            self.post.action_count[key] = 0

    def micro_actions(self, action, val=''):
        weight = 0.0
        stores = []
        if self.user.account_id == self.post.account.account_id and action == 'save':
            return None
        elif action == "love":
            commited = self.commit_action(loved=True, loved_at=get_ist())
            weight = WEIGHT_LOVE
            if commited:
                self.increment('love', weight)
        elif action == "un_love":
            commited = self.commit_action(loved=False)
            weight = - WEIGHT_LOVE
            if commited:
                self.decrement('love', 0.0)
        elif action == "share":
            commited = self.commit_action(shared=True)
            weight = WEIGHT_SHARE
            if commited:
                self.increment('share', weight)
        elif action == "view":
            commited = self.commit_action(viewed=True, viewed_at=get_ist())
            weight = WEIGHT_VIEW
            if commited:
                self.increment('view', weight)
        elif action == "save":
            commited = self.commit_action(saved=True)

            weight = WEIGHT_SAVE
            if commited:
                self.user.saves.append(self.post.post_id)
                self.increment('save', weight)

        elif action == "un_save":
            commited = self.commit_action(saved=False)
            weight = - WEIGHT_SAVE
            if commited:
                self.user.saves.remove(self.post.post_id)
                self.increment('save', weight)
        elif action == "comment":
            commited = self.commented(val)
            weight = WEIGHT_COMMENT
            if commited:
                self.increment('comment', weight)
        self.post.save()
        self.score_post.delay(
            self.post.post_id, self.user.account_id, weight=weight)


# @shared_task
def authenticated_mirco_actions(GET, token, req_type='GET'):
    if token:
        token = "".join(token.split('Token ')) if 'Token' in token else token
        tokens: QuerySet = Token.objects.filter(key=token)
        if not tokens:
            return None
        token = tokens.first()
        account: Account = token.user

        data = {}
        if req_type == "POST":
            data = GET
        elif req_type == "GET":
            data = GET
        # print(f"{account.account_id},{data['action']}")
        micro_action = MicroActions(data['pid'], account=account)
        micro_action.micro_actions(
            data['action'], val=data['comment'] if data['action'] == "comment" else '')
        return None
    else:
        return None


@shared_task
def authenticated_association(token, fid, follow=True):
    tk = "".join(token.split('Token ')) if 'Token' in token else token
    tokens: QuerySet = Token.objects.filter(key=tk)
    if not tokens:
        return None
    token = tokens.first()
    user: Account = token.user
    followes: QuerySet = Account.objects.filter(account_id=fid)
    if not followes:
        return None
    if follow:
        MicroActions.follow_user(followes.first(), user)
    return None


@shared_task
def general_micro_actions(get):
    data = get
    micro_action = MicroActions(data['pid'])
    micro_action.micro_actions(data['action'])
    return None
