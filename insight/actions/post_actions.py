from celery import shared_task
from insight.models import *
import json
from insight.utils import *
from django.db.models import Q, QuerySet
from insight.manager.analyzer import Analyzer

"""
 Micro Actions are set of actions included in the post, generally used for expression about the post by the viewer.
 The Actions are View, Love, UnLove, Share, Save, UnSave, Comment
 View is ought to be first action, fired instantly when intersection of post with viewport is 1.
 Save, UnSave and Comment are only allowed to Registered users.
 Every Action will create or update an ActionStore with unique pair of post_id and account_id
 The meta score will be updated instantly after the action is fired.
"""

WEIGHT_VIEW: float = 0.25
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
    
    @shared_task
    def score_post(post_id,user_id,weight=0.0):
        # if self.anonymous:
        #     return self.post.score + weight
        user = Account.objects.get(pk=user_id)
        post = Post.objects.get(pk=post_id)
        if user.primary_hobby:
            primary_hobby_weight: float = float(Hobby.objects.get(code_name=user.primary_hobby).weight)
        else:
            primary_hobby_weight = 0.0
        post_hobby_weight: float = float(post.hobby.weight)
        multiplier: float = float(
            user.hobby_map[post.hobby.code_name] if post.hobby.code_name in user.hobby_map else 1)
        hobby_distance: float = 1 + abs(primary_hobby_weight - post_hobby_weight) / multiplier

        # date_distance = abs((get_ist() - post.created_at).seconds) + 1

        comment_score: float = 1.0 + float(WEIGHT_COMMENT * post.action_count['comment'])
        love_score: float =  1.0 + float(WEIGHT_LOVE * post.action_count['love'])
        share_score: float = 1.0 + float(WEIGHT_SHARE * post.action_count['share'])
        save_score: float = 1.0 + float(WEIGHT_SAVE * post.action_count['save'])
        view_score: float = 1.0 + float(WEIGHT_VIEW * post.action_count['view'])
        # print(comment_score,love_score,share_score,save_score,view_score,hobby_distance)
        score =  1 + (comment_score * love_score * share_score * save_score * view_score) / (
               hobby_distance)
        post.score = score
        post.save()

    def commit_action(self, **action):
        print('active')
        if self.user:
            action_stores = ActionStore.objects.filter(Q(post_id=self.post.post_id) &
                                                                     Q(account_id=self.user.account_id))
            if not action_stores:
                return None
            action_store = action_stores.first()
            if 'viewed' in action and action_store.viewed:
                return None 
            else:
                print(action)
                action_store.__class__.objects.update(**action)               
        return None

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
        print(f"{followed.username},{user.username},'follow'")
        if not user.following:
            user.following = []
        if followed.account_id in user.following:
            return None
        user.following.append(followed.account_id)
        user.following_count  = len(user.following)
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
        print(f"{followed.username},{user.username},'un_follow'")
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


    def micro_actions(self, action, val=''):
        weight = 0.0
        stores = []
        if self.user.account_id == self.post.account.account_id and action == 'save':
            return None
        elif action == "love":
            self.commit_action(loved=True,loved_at=get_ist())
            weight = WEIGHT_LOVE
            self.post.action_count['love'] += 1
            self.analyzer.analyze(self.post, WEIGHT_LOVE)
        elif action == "un_love":
            self.commit_action(loved=False)
            weight = 0.0
            if self.post.action_count['love'] > 0:
                self.post.action_count['love'] -= 1
            else:
                self.post.action_count['love'] = 0
        elif action == "share":
            self.commit_action(shared=True)
            weight = WEIGHT_SHARE

            self.analyzer.analyze(self.post, WEIGHT_SHARE)
            self.post.action_count['share'] += 1
        elif action == "view":
            self.commit_action(viewed=True,viewed_at=get_ist())
            weight = WEIGHT_VIEW

            self.post.action_count['view'] += 1
            self.analyzer.analyze(self.post, WEIGHT_VIEW)
        elif action == "save":
            self.commit_action(saved=True)
            self.user.saves.append(self.post.post_id)
            weight = WEIGHT_SAVE

            self.post.action_count['save'] += 1
            self.analyzer.analyze(self.post, WEIGHT_SAVE)
        elif action == "un_save":
            self.commit_action(saved=False)
            self.user.saves.remove(self.post.post_id)
            weight = 0.0
            if self.post.action_count['save'] > 0:
                self.post.action_count['save'] -= 1
            else:
                self.post.action_count['save'] = 0
        elif action == "comment":
            self.commented(val)
            weight = WEIGHT_COMMENT
            self.post.action_count['comment'] += 1
            self.analyzer.analyze(self.post, WEIGHT_COMMENT)
        self.post.save()
        self.score_post.delay(self.post.post_id,self.user.account_id,weight=weight)
        

# @shared_task
def authenticated_mirco_actions(GET,token,req_type='GET'):
    if token:
        token = "".join(token.split('Token ')) if 'Token' in token else token
        tokens: QuerySet = Token.objects.filter(key=token)
        if not tokens:
            return None
        token = tokens.first()
        account: Account = token.user

        data = {}
        if req_type == "POST":
            data = json.load(GET)
        elif req_type == "GET":
            data = GET
        # print(f"{account.account_id},{data['action']}")
        micro_action = MicroActions(data['pid'], account=account)
        micro_action.micro_actions(data['action'], val=data['comment'] if data['action'] == "comment" else '')
        return None
    else:
        return None

@shared_task
def authenticated_association(token,fid, follow=True):
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
        MicroActions.follow_user(followes.first(),user)
    return None

@shared_task
def general_micro_actions(get):
    data = get
    micro_action = MicroActions(data['pid'])
    micro_action.micro_actions(data['action'])
    return None
