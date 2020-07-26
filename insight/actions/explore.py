from django.db.models import Q
from insight.models import Post, UserActionRef


class Explorer:
    def __init__(self, *account):
        if account:
            self.account = account[0]

    @staticmethod
    def explore_anonymous():
        posts = Post.objects.all().order_by('score', '-created_at')
        return posts

    def explore_known(self):
        hobby_map = self.account.hobby_map
        filters = None
        for hobby in hobby_map:
            if not filters:
                filters = Q(hobby=hobby)
            else:
                filters = filters | Q(hobby=hobby)
        posts = Post.objects.filter(filters).order_by('score', '-created_at')
        return posts

    @staticmethod
    def filter_hobby(hobby):
        return Post.objects.filter(hobby=hobby).order_by('score', '-created_at')

    @staticmethod
    def serialize_post(post):
        return {"post_id": post.post_id, "score": post.score, "hobby": post.hobby, "hobby_name": post.hobby_name,
                "assets": post.assets
                }
