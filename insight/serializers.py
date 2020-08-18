from .models import *
from .utils import *
from rest_framework.serializers import ModelSerializer


class PostSerializer:

    def __init__(self, *posts):
        self.posts = posts[0]
        if self.posts:
            self.post = self.posts[0]

    def render(self):
        renderd = []
        for post in self.posts:
            self.post = post
            user = Account.objects.filter(account_id=self.post.account_id)
            if user:
                renderd.append(self.serialize(user.first()))
        return renderd

    def render_with_action(self, actions):
        renderd =[]
        if len(self.posts) == 0:
            return renderd
        for post in self.posts:
            self.post = post
            user = Account.objects.filter(account_id=self.post.account_id)
            if user:
                serialized = self.serialize()
                if len(actions) > 0 and self.post.post_id in actions:
                    serialized['meta']['actions'] = actions[self.post.post_id]
                else:
                    serialized['meta']['actions'] = {'loved':0,'shared':0,'saved':0,'viewed':0}
                renderd.append(serialized)
        return renderd

    def serialize(self,user, *delete_keys):
        data = {'header': {}, 'body': {}, 'caption': {}, 'footer': {}, 'meta': {}, 'post_id': self.post.post_id}
        data['meta']['score'] = self.post.score
        data['meta']['created'] = f'{((get_ist() - self.post.created_at).seconds / 3600)}h'
        data['meta']['editor'] = self.post.editor
        data['meta']['account_id'] = user.account_id
        data['header']['avatar'] = self.post.avatar
        data['header']['username'] = self.post.username
        data['header']['hobby_name'] = self.post.hobby_name
        data['header']['hobby'] = self.post.hobby
        data['header']['rank'] = self.post.rank if self.post.rank != 0 else 'null'
        data['header']['influencer'] = 1 if user.influencer and user.influencing_hobby == self.post.hobby else 0
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
                  'description','places'
                  )


class ExplorePostSerializer(ModelSerializer):
    class Meta:
        model = Post
        fields = ('post_id', 'assets', 'captions', 'score', 'hobby', 'hobby_name', 'created_at', 'editor')


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
