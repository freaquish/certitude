from .models import *
from .utils import *
from rest_framework.serializers import ModelSerializer


class PostSerializer:

    def __init__(self, *posts):
        self.posts = posts
        if self.posts:
            self.post = self.posts[0]

    def render(self):
        renderd = []
        for post in self.posts:
            self.post = post
            renderd.append(self.serialize())
        return renderd

    def serialize(self, *delete_keys):
        user: Account = Account.object.get(account_id=self.post.account_id)
        data = {'header': {}, 'body': {}, 'caption': {}, 'footer': {}, 'meta': {}, 'post_id': self.post.post_id}
        data['meta']['score'] = self.post.score
        data['meta']['created'] = f'{((get_ist() - self.post.created_at).seconds / 3600)}h'
        data['meta']['editor'] = self.post.editor
        data['header']['avatar'] = self.post.avatar
        data['header']['username'] = self.post.username
        data['header']['hobby_name'] = self.post.hobby_name
        data['header']['hobby'] = self.post.hobby
        data['header']['rank'] = self.post.rank if self.post.rank != 0 else 'null'
        data['header']['influencer'] = 1 if user.influencer and user.influencing_hobby == self.post.hobby else 0
        data['body'] = self.post.assets
        data['caption'] = self.post.caption
        data['footer'] = self.post.action_count
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
                  'description'
                  )


class ExplorePostSerializer(ModelSerializer):
    class Meta:
        model = Post
        fields = ('post_id', 'assets', 'captions', 'score', 'hobby', 'hobby_name', 'created_at', 'editor')
