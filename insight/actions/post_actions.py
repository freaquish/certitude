from celery import shared_task
from insight.models import *
import json
from insight.utils import *
from django.db.models import Q, QuerySet

"""
 Micro Actions are set of actions included in the post, generally used for expression about the post by the viewer.
 The Actions are View, Love, UnLove, Share, Save, UnSave, Comment
 View is ought to be first action, fired instantly when intersection of post with viewport is 1.
 Save, UnSave and Comment are only allowed to Registered users.
 Every Action will create or update an ActionStore with unique pair of post_id and account_id
 The meta score will be updated instantly after the action is fired.
"""

WEIGHT_VIEW: float = 0.35
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
        self.anonymous = anonymous

    def score_post(self,weight=0.0):
        if self.anonymous:
            return self.post.score + weight
        primary_hobby_weight: float = float(Hobby.objects.get(code_name=self.user.primary_hobby).weight)
        post_hobby_weight: float = float(Hobby.objects.get(code_name=self.post.hobby).weight)
        multiplier: float = float(
            self.user.hobby_map[self.post.hobby] if self.post.hobby in self.user.hobby_map else 1)
        hobby_distance: float = 1 + abs(primary_hobby_weight - post_hobby_weight) / multiplier

        date_distance = abs((get_ist() - self.post.created_at).seconds) + 1

        comment_score: float = float(WEIGHT_COMMENT * self.post.action_count['comment'])
        love_score: float = float(WEIGHT_LOVE * self.post.action_count['love'])
        share_score: float = float(WEIGHT_SHARE * self.post.action_count['share'])
        save_score: float = float(WEIGHT_SAVE * self.post.action_count['save'])
        view_score: float = float(WEIGHT_VIEW * self.post.action_count['view'])
        return 1 + (comment_score * love_score * share_score * save_score * view_score) / (
                date_distance * hobby_distance)

    def commit_action(self, **action):
       if self.user and not self.anonymous:
           action_store, created = ActionStore.objects.get_or_create(post_id=self.post.post_id,
                                                                     account_id=self.user.account_id)
           action_store.objects.update(**action)

    def commented(self, value):
        if self.user:
            comment = PostComment.objects.get_or_created(post_id=self.post.post_id)[0]
            comment.comments.append({'username': self.user.username,
                                     'account_id': self.user.account_id,
                                     'name': self.user.first_name + " " + self.user.last_name,
                                     'image': self.user.avatar,
                                     'data': value
                                     })
            comment.save()
            self.commit_action(commented=True)

    def micro_actions(self, action, val=''):
        weight = 0.0
        if action == "love":
            self.commit_action(loved=True)
            weight = WEIGHT_LOVE
        elif action == "un_love":
            self.commit_action(loved=False)
            weight = 0.0
        elif action == "share":
            self.commit_action(shared=True)
            weight = WEIGHT_SHARE
        elif action == "view":
            self.commit_action(viewed=True)
            weight = WEIGHT_VIEW
        elif action == "save":
            self.commit_action(saved=True)
            self.user.saves.append(self.post.post_id)
            weight = WEIGHT_SAVE
        elif action == "un_save":
            self.commit_action(saved=False)
            self.user.saves.remove(self.post.post_id)
            weight = 0.0
        elif action == "comment":
            self.commented(val)
            weight = WEIGHT_COMMENT
        if action == "un_love":
            self.post.action_count['love'] -= 1
        elif action == "un_save":
            self.post.action_count['save'] -= 1
        else:
            self.post.action_count[action] += 1
        self.post.score = self.score_post(weight=weight)
        self.post.save()

@shared_task
def authenticated_mirco_actions(GET,token,req_type='GET'):
    if token:
        token = "".join(token.split('Token ')) if 'Token' in token else token
        accounts: QuerySet = Token.objects.filter(key=token)
        if not accounts:
            return None
        account: Account = accounts.first()
        data = {}
        if req_type == "POST":
            data = json.load(GET)
        elif req_type == "GET":
            data = GET
        micro_action = MicroActions(data['pid'], account=account)
        micro_action.micro_actions(data['action'], val=data['comment'] if data['action'] == "comment" else '')
        return None
    else:
        return None


@shared_task
def general_micro_actions(get):
    data = get
    micro_action = MicroActions(data['pid'])
    micro_action.micro_actions(data['action'])
    return None

