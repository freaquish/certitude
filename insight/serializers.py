from .models import *
from .utils import *
from rest_framework.serializers import ModelSerializer

from django.db.models import QuerySet


class PostSerializer:

    def __init__(self, posts: QuerySet, **args):
        self.posts: QuerySet = posts
        self.user = None
        if args and 'user' in args:
            self.user = args.get('user')

    @staticmethod
    def is_asset_valid(asset):
        if len(asset) == 0:
            return False
        if "images" in asset and len(asset["images"]) == 0:
            return False
        if "video" in asset and len(asset["video"]) == 0:
            return False
        if "audio" in asset and len(asset["audio"]) == 0:
            return False
        return True

    def serializer(self, post: Post):
        if not self.is_asset_valid(post.assets):
            return None
        data = {"created_at": post.created_at, "header": {}, "body": post.assets,
                "caption": "", "footer": {}, "meta": {}, "post_id": post.post_id,
                "isSelf": 1 if post.account == self.user else 0}
        data["meta"]["score"] = post.score
        time_left = get_ist() - post.created_at
        data["meta"]["created"] = '{0:.2f}d'.format(time_left.days) if time_left.days >= 1 else '{0:.2f}h'.format(
             time_left.seconds / 3600)
        data["meta"]["account_id"] = post.account.account_id
        data["header"]["avatar"] = post.account.avatar
        data["header"]["username"] = post.account.username
        data["header"]["name"] = post.account.first_name + " " + post.account.last_name
        data["header"]["hobby_name"] = post.hobby.name
        data["header"]["hobby"] = post.hobby.code_name
        data["header"]["following"] = 0
        if self.user and (post.account == self.user or post.account.account_id in self.account.following):
            data['header']['following'] = 1
        data["caption"] = post.caption
        data["footer"]["action_map"] = {
            "view": post.views.count(),
            "love": post.loves.count(),
            "share": post.shares.count(),
            "comment": post.comments.count()
        }
        data["meta"]["actions"] = {}
        data["meta"]["actions"]["viewed"] = 1 if post.views.filter(account_id=self.user.account_id).exists() else 0
        data["meta"]["actions"]["loved"] = 1 if post.loves.filter(account_id=self.user.account_id).exists() else 0
        data["meta"]["actions"]["shared"] = 1 if post.shares.filter(account_id=self.user.account_id).exists() else 0
        return data

    def render(self):
        rendered = []
        for post in self.posts:
            serialise = self.serializer(post)
            if serialise is None:
                continue
            rendered.append(serialise)
        return rendered


class HobbySerializer(ModelSerializer):
    class Meta:
        model = Hobby
        fields = '__all__'


class ProfileSerializer(ModelSerializer):
    class Meta:
        model = Account
        fields = ('account_id', 'avatar', 'first_name', 'last_name', 'username',
                  'follower_count', 'following_count',
                  'description'
                  )


class ExplorePostSerializer(ModelSerializer):
    class Meta:
        model = Post
        fields = ('post_id', 'assets', 'captions',
                  'score', 'hobby', 'created_at', 'editor')


class ActionStoreSerializer:

    def __init__(self, actions):
        self.actions = actions

    @staticmethod
    def _render(action: ActionStore):
        return {
            "viewed": 1 if action.viewed else 0,
            "loved": 1 if action.loved else 0,
            "shared": 1 if action.shared else 0,
            "saved": 1 if action.saved else 0,
        }

    def data(self):
        json = {}
        for action in self.actions:
            json[action.post_id] = self._render(action)
        return json


class ShallowPostSerializer:
    def __init__(self, posts):
        self.posts = posts

    @staticmethod
    def _serialise(post: Post):
        return {
            "assets": post.assets,
            "post_id": post.post_id,
            "meta": {
                "account_id": post.account.account_id,
                "username": post.account.username,
                "avatar": post.account.avatar
            }
        }

    def data(self):
        renderd = []
        for post in self.posts:
            renderd.append(self._serialise(post))
        return renderd


class CommentSerializer:
    def __init__(self, comments):
        self.comments = comments

    def _serialise(self, comment: UserPostComment):
        time_left = get_ist() - comment.created_at
        return {
            "account": {
                "account_id": comment.account.account_id,
                "username": comment.account.username,
                "name": comment.account.first_name + ' ' + comment.account.last_name,
                "avatar": comment.account.avatar
            },
            "comment": comment.comment,
            "created": f'{time_left}d' if time_left.days > 0 else '{0:.2f}h'.format(time_left.seconds / 3600)
        }

    def render(self):
        renderd = [self._serialise(comment) for comment in self.comments]
        return renderd
