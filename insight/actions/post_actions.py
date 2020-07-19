from celery import shared_task
from insight.models import *
from insight.utils import *
from django.db.models import Q, QuerySet

WEIGHT_VIEW: float = 0.35
WEIGHT_LOVE: float = 0.50
WEIGHT_COMMENT: float = 0.65
WEIGHT_SAVE: float = 0.80
WEIGHT_SHARE: float = 0.95
WEIGHT_FOLLOWER: float = 0.30
WEIGHT_FOLLOWING: float = 0.45
WEIGHT_FRIEND: float = 0.85


class MicroActions:

    def __init__(self, post_id: str, account_id=None, coords=None):
        self.post_id: str = post_id

        if account_id:
            self.account_id: str = account_id
            self.user = Account.objects.get(account_id=self.account_id)
            self.coords = json_to_coord(coords)
        else:
            self.account_id = None
        self.post = Post.objects.get(post_id=self.post_id)
        self.poster = Account.objects.get(account_id=self.post.account_id)

    def love_action(self):
        self.post.action_count['love'] += 1
        self.post.save()
        self.post.score = self.score_post(anonymous=True if not self.account_id else False, weight=WEIGHT_LOVE)
        self.post.save()
        if self.account_id:
            self.user.objects.insert_coords(self.coords)
            actions = UserActionRef.objects.filter(
                Q(Q(account_id=self.account_id & Q(Q(hobby=self.post.hobby) & Q(date_created=get_ist_data())))))
            action = None
            if action:
                action = actions.first()
            else:
                action = UserActionRef.objects.create(account_id=self.account_id, hobby=self.post.hobby,
                                                      date_created=get_ist_data(), time_created=get_ist_time())
            action.loves.append(self.post_id)
            action.save()

    def un_love_action(self):
        self.post.action_count['love'] -= 1
        self.post.save()
        self.post.score = self.score_post(anonymous=True if not self.account_id else False, weight=-WEIGHT_LOVE)
        self.post.save()
        if self.account_id:
            self.user.objects.insert_coords(self.coords)
            actions = UserActionRef.objects.filter(
                Q(Q(account_id=self.account_id & Q(Q(hobby=self.post.hobby) & Q(date_created=get_ist_data())))))
            if actions:
                action = actions.first()
                action.loves.remove(self.post_id)
                action.save()

    def view_action(self):
        self.post.action_count['view'] += 1
        self.post.save()
        self.post.score = self.score_post(anonymous=True if not self.account_id else False, weight=WEIGHT_VIEW)
        self.post.save()
        if self.account_id:
            self.user.objects.insert_coords(self.coords)
            actions = UserActionRef.objects.filter(
                Q(Q(account_id=self.account_id & Q(Q(hobby=self.post.hobby) & Q(date_created=get_ist_data())))))
            action = None
            if action:
                action = actions.first()
            else:
                action = UserActionRef.objects.create(account_id=self.account_id, hobby=self.post.hobby,
                                                      date_created=get_ist_data(), time_created=get_ist_time())
            action.views.append(self.post_id)
            action.save()

    def share_action(self):
        self.post.action_count['share'] += 1
        self.post.save()
        self.post.score = self.score_post(anonymous=True if not self.account_id else False, weight=WEIGHT_SHARE)
        self.post.save()
        if self.account_id:
            self.user.objects.insert_coords(self.coords)
            actions = UserActionRef.objects.filter(
                Q(Q(account_id=self.account_id & Q(Q(hobby=self.post.hobby) & Q(date_created=get_ist_data())))))
            action = None
            if action:
                action = actions.first()
            else:
                action = UserActionRef.objects.create(account_id=self.account_id, hobby=self.post.hobby,
                                                      date_created=get_ist_data(), time_created=get_ist_time())
            action.shares.append(self.post_id)
            action.save()

    def save_action(self):
        # Compulsory to have account
        self.post.action_count['save'] += 1
        self.user.saves.push(self.post.post_id)
        self.post.save()
        self.post.score = self.score_post()
        self.post.save()
        self.user.objects.insert_coords(self.coords)
        actions = UserActionRef.objects.filter(
            Q(Q(account_id=self.account_id & Q(Q(hobby=self.post.hobby) & Q(date_created=get_ist_data())))))
        action = None
        if action:
            action = actions.first()
        else:
            action = UserActionRef.objects.create(account_id=self.account_id, hobby=self.post.hobby,
                                                  date_created=get_ist_data(), time_created=get_ist_time())
        action.saves.append(self.post_id)
        action.save()

    def un_save_action(self):
        self.post.action_count['save'] -= 1
        self.user.saves.remove(self.post_id)
        self.post.save()
        self.post.score = self.score_post()
        self.post.save()
        self.user.objects.insert_coords(self.coords)
        actions = UserActionRef.objects.filter(
            Q(Q(account_id=self.account_id & Q(Q(hobby=self.post.hobby) & Q(date_created=get_ist_data())))))
        action = None
        if action:
            action = actions.first()
            action.saves.remove(self.post_id)
            action.save()

    def comment_action(self, text: str):
        # compulsory to have account
        self.post.action_count['comment'] += 1
        self.post.save()
        comment = PostComment.objects.get_or_created(post_id=self.post_id)[0]
        comment.comments.append({'username': self.account_id.username,
                                 'account_id': self.account_id,
                                 'name': self.user.first_name + " " + self.user.last_name,
                                 'image': self.user.avatar,
                                 'data': text
                                 })
        comment.save()
        self.user.objects.insert_coords(self.coords)
        self.post.score = self.score_post()
        self.post.save()

    def score_post(self, anonymous=False, weight=0.0):
        if anonymous:
            return self.post.score + weight
        primary_hobby_weight: float = float(Hobby.objects.get(code_name=self.user.primary_hobby).weight)
        post_hobby_weight: float = float(Hobby.objects.get(code_name=self.post.hobby).weight)
        multiplier: float = float(
            self.poster.hobby_map[self.post.hobby] if self.post.hobby in self.poster.hobby_map else 1)
        hobby_distance: float = 1 + abs(primary_hobby_weight - post_hobby_weight) / multiplier

        date_distance = abs((get_ist() - self.post.created_at).seconds) + 1

        comment_score: float = float(WEIGHT_COMMENT * self.post.action_count['comment'])
        love_score: float = float(WEIGHT_LOVE * self.post.action_count['love'])
        share_score: float = float(WEIGHT_SHARE * self.post.action_count['share'])
        save_score: float = float(WEIGHT_SAVE * self.post.action_count['save'])
        view_score: float = float(WEIGHT_VIEW * self.post.action_count['view'])
        return 1 + (comment_score * love_score * share_score * save_score * view_score) / (
                date_distance * hobby_distance)


def micro_action(action, post_id, account_id=None, coords=None, text=None):
    micro_actions = MicroActions(post_id, account_id=account_id, coords=coords)
    if action == 'love':
        micro_actions.love_action()
    elif action == 'view':
        micro_actions.view_action()
    elif action == 'share':
        micro_actions.share_action()
    elif action == 'un_love':
        micro_actions.un_love_action()
    return None


@shared_task
def save_micro_action(get, token_str, save=True):
    token: str = token_str
    token = "".join(token.split('Token ')) if 'Token' in token else token
    token_objects: QuerySet = Token.objects.filter(key=token)
    if token_objects:
        token_object: Token = token_objects.first()
        account: Account = token_object.user
        micro_actions = MicroActions(get['pid'], account_id=account.account_id,
                                     coords={'lat': get['coord_x'], 'long': get['coord_y']})
        if save:
            micro_actions.save_action()
        else:
            micro_actions.un_save_action()
    return None


@shared_task
def comment_micro_action(post, token_str):
    token: str = token_str
    token = "".join(token.split('Token ')) if 'Token' in token else token
    token_objects: QuerySet = Token.objects.filter(key=token)
    if token_objects:
        token_object: Token = token_objects.first()
        account: Account = token_object.user
        micro_actions = MicroActions(post['pid'], account_id=account.account_id,
                                     coords={'lat': post['coord_x'], 'long': post['coord_y']})
        micro_actions.comment_action(post['text'])
    return None


@shared_task
def subsiquent_micro_actions(action, get, token_str=None):
    account_id = None
    coords = None
    if token_str:
        token: str = token_str
        token = "".join(token.split('Token ')) if 'Token' in token else token
        token_objects: QuerySet = Token.objects.filter(key=token)
        if token_objects:
            token_object: Token = token_objects.first()
            account: Account = token_object.user
            account_id = account.account_id
            coords = {'lat': get['coord_x'], 'long': get['coord_y']}
    micro_action(action, get['pid'], account_id=account_id, coords=coords)
    return None
