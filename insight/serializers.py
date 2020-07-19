from .models import *
from .utils import *
from rest_framework.serializers import ModelSerializer


class PostSerializer:

    def __init__(self, post: Post ):
        self.post: Post = post

    def serialize(self):
        user: Account = Account.object.get(account_id=self.post.account_id)
        data: dict = {}
        data['header'] = {}
        data['body'] = {}
        data['caption'] = {}
        data['footer'] = {}
        data['meta'] = {}
        data['post_id'] = self.post.post_id
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
        return data

