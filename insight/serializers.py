from .models import *
from .utils import *
from rest_framework.serializers import ModelSerializer

from django.db.models import Q


class PostSerializer:

    def __init__(self, *kwarg):
        self.kwarg = kwarg
        self.post = None
        self.account = None
        if self.kwarg:
            self.posts = self.kwarg[0]
            # print(self.posts)
            # self.post = self.posts[0]
            if len(self.kwarg) > 1:
                self.account = self.kwarg[1]

    @staticmethod
    def is_asset_valid(asset):
        if len(asset) == 0:
            return False
        else:
            if "images" in asset and len(asset["images"]) == 0:
                return False
            if "video" in asset and not asset["video"]:
                return False
            if "audio" in asset and not asset["audio"]:
                return False
            if "text" in asset and not asset["text"]:
                return False
        return True

    def render(self):
        renderd = []
        for post in self.posts:
            if not self.is_asset_valid(post.assets):
                continue
            self.post = post
            user = self.post.acount
            if user:
                renderd.append(self.serialize(user))
        return renderd

    def render_with_action(self, actions):
        renderd = []
        if len(self.posts) == 0:
            return renderd
        for post in self.posts:
            if not self.is_asset_valid(post.assets):
                continue
            self.post = post
            user = self.post.account
            if user:
                serialized = self.serialize(user)
                serialized['meta']['actions'] = {
                    'loved': 0, 'shared': 0, 'saved': 0, 'viewed': 0}
                post_actions = actions.filter(
                    Q(account_id=self.account.account_id) & Q(post_id=self.post.post_id))
                if post_actions:
                    post_action = post_actions.first()
                    #print(post_actions, post_action.loved)
                    # print(serialized['footer']['action_map']['view'] > 0 and post_action.viewed)
                    if post_action.loved and serialized['footer']['action_map']['love'] > 0:
                        serialized['meta']['actions']['loved'] = 1
                    if serialized['footer']['action_map']['view'] > 0 and post_action.viewed:
                        # print('Im happening')
                        serialized['meta']['actions']['viewed'] = 1
                    if serialized['footer']['action_map']['share'] > 0 and post_action.shared:
                        serialized['meta']['actions']['shared'] = 1
                    if serialized['footer']['action_map']['save'] > 0 and post_action.saved:
                        serialized['meta']['actions']['saved'] = 1
                # print(serialized['meta']['actions'])
                renderd.append(serialized)
        return renderd

    def serialize(self, user, *delete_keys):
        # check if account is following the user
        data = {'created_at': self.post.created_at, 'header': {}, 'body': {
        }, 'caption': {}, 'footer': {}, 'meta': {}, 'post_id': self.post.post_id}
        data['meta']['score'] = self.post.score
        data['meta']['created'] = f'{((get_ist() - self.post.created_at).seconds / 3600)}h'
        data['meta']['editor'] = self.post.editor
        data['meta']['account_id'] = user.account_id
        data['header']['avatar'] = user.avatar
        data['header']['username'] = user.username
        data['header']['hobby_name'] = self.post.hobby.name
        data['header']['hobby'] = self.post.hobby.code_name
        data['header']['following'] = 0
        if self.account and (user == self.account or self.post.account.account_id in self.account.following):
            data['header']['following'] = 1

        data['header']['rank'] = self.post.rank if self.post.rank != 0 else 'null'
        data['header']['influencer'] = 1 if user.influencer and user.influencing_hobby == self.post.hobby.code_name else 0
        data['body'] = self.post.assets
        data['caption'] = self.post.caption
        data['footer']['action_map'] = self.post.action_count
        if delete_keys:
            for key in delete_keys:
                del data[key]
        return data


class HobbySerializer(ModelSerializer):
    class Meta:
        model = Hobby
        fields = '__all__'


class ProfileSerializer(ModelSerializer):
    class Meta:
        model = Account
        fields = ('account_id', 'avatar', 'first_name', 'last_name', 'username',
                  'influencer', 'hobby_map', 'follower_count', 'following_count', 'friend_count',
                  'description', 'places'
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
    def _serialise(post:Post):
        return {
            "assets": post.assets,
            "post_id":post.post_id,
            "meta":{
                "account_id":post.account.account_id,
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

    def _serialise(self,comment: UserPostComment):
        time_left = get_ist() - comment.created_at
        return {
            "account":{
                "account_id": comment.account.account_id,
                "username": comment.account.username,
                "name": comment.account.first_name + ' '+ comment.account.last_name,
                "avatar": comment.account.avatar 
            },
            "comment": comment.comment,
            "created": f'{time_left}d' if time_left.days > 0 else '{0:.2f}h'.format(time_left.seconds / 3600)
        }
    def render(self):
        renderd = [self._serialise(comment) for comment in self.comments]
        return renderd 
