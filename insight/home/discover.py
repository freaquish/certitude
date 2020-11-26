from insight.models import Account, Post, get_ist
from django.db.models import QuerySet, Q, ExpressionWrapper, Value, F, DecimalField
from django.db.models.functions import Exp, ExtractDay, Now


class AbstractDiscover:

    def __init__(self, user=None, hobbies=None):
        self.user: Account = user
        self.hobbies = hobbies

    def hobby_query(self) -> any:
        """
        Creates hobby query using self.hobbies if self.hobbies is None
        then '__all__' will be returned
        """
        pass

    def extract_queryset(self, query) -> QuerySet:
        """
        Return queryset according to net_score, and retention and hobby relevancy
        explore will have no bound of data representation except popularity
        """
        pass

    def rendered_data(self, queryset: QuerySet) -> list:
        """
        Renders post instance to json sending only bard data
        if image > video > audio is priority and
        text is sent without assets unless text.length is smaller than 50
        """
        pass


class Discover(AbstractDiscover):

    def hobby_query(self) -> any:
        if not self.hobbies:
            return '__all__'
        query = None
        for hobby in self.hobbies:
            if query:
                query = query | Q(hobby__code_name=hobby)
            else:
                query = Q(hobby__code_name=hobby)
        return query

    def extract_queryset(self, query) -> QuerySet:
        annotations = {
            "f_score": Exp(ExpressionWrapper(Value(1 / 4) * ExtractDay('created_at') - ExtractDay(Now()) + Value(0.8),
                                             output_field=DecimalField())),
            "action_score": F("score")
        }
        if query != '__all__':
            posts: QuerySet = Post.objects.select_related('hobby', 'account').filter(query).annotate(**annotations)\
                .exclude(account=self.user)
        else:
            posts: QuerySet = Post.objects.select_related("account").annotate(**annotations).exclude(account=self.user)
        return posts

    @staticmethod
    def get_asset(post: Post):
        if "text" in post.assets and len(post.assets["text"]["data"]) > 0:
            if "images" in post.assets and len(post.assets["images"]) > 0:
                return post.assets["images"][0]
            else:
                return post.assets["text"]
        elif "images" in post.assets and len(post.assets["images"]) > 0:
            return post.assets["images"][0]
        elif "video" in post.assets and len(post.assets["video"]) > 0:
            return post.assets["video"]
        elif "audio" in post.assets and len(post.assets["audio"]) > 0:
            return post.assets["audio"]
        else:
            return None

    def serialize(self, post: Post):
        assets = self.get_asset(post)
        if assets is None:
            return None
        return {
            "post_id": post.post_id,
            "asset": assets,
            "account": {
                "avatar": post.account.avatar,
                "username": post.account.username
            }
        }

    def rendered_data(self, queryset) -> list:
        rendered = []
        if queryset.__class__ == QuerySet:
            for post in queryset.iterator():
                render = self.serialize(post)
                if post is None:
                    continue
                rendered.append(render)
        else:
            for post in queryset:
                render = self.serialize(post)
                if post is None:
                    continue
                rendered.append(render)
        return rendered


