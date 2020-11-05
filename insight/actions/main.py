from insight.models import Post, ActionStore, Account, ScorePost, UserPostComment
from celery import shared_task
from insight.workers.analyzer import Analyzer
from django.db.models import QuerySet
from insight.utils import get_ist
from insight.workers.analyzer import Analyzer
from math import exp

weights = {
    'love': 0.50,
    'view': 0.15,
    'share': 0.65,
    'save': 0.60
}


class PostActions:
    def __init__(self, user: Account, post: Post):
        self.user: Account = user
        self.post: Post = post

    def commented(self, value):
        if self.user:
            comment = UserPostComment.objects.create(
                post_id=self.post.post_id, account=self.user, created_at=get_ist(), comment=value)
            return self.commit_action('comment')

    """
    Serious Improvement required, suppose user base grown to 10 million and 5 million post
    recorded 1000 actions each, then 1000 * 5 million
    total stores = 5000000000 stores
    select query will be extremely slow, we need to index the account_id and post_id
    needed to introduce some serious arch.
    I think in the coming age all of the backend should be re-written
    
    The write should be in go
    """
    def commit_action(self, action):
        if action == 'viewed':
            return False
        action_store, created = ActionStore.objects.get_or_create(
            account_id=self.user.account_id, post_id=self.post.post_id
        )
        if action == 'view' and action_store.viewed:
            return False
        elif action == 'view':
            action_store.viewed = True
            action_store.viewed_at = get_ist()
            self.increment('view')
        elif action == 'love' or action == 'un_love':
            action_store.loved = not action_store.loved
            action_store.loved_at = get_ist()
            if action_store.loved:
                self.increment('love')
            else:
                self.decrement('love')
        elif action == 'share':
            action_store.shared = True
            self.increment('share')
        elif action == 'comment':
            action_store.commented = True
            self.increment('comment')
        action_store.save()
        return True

    @staticmethod
    @shared_task
    def score_post(post_id: str, account_id: str):
        posts: QuerySet = Post.objects.filter(post_id=post_id)
        if not posts:
            return None
        post: Post = posts.first()
        account = Account.objects.get(account_id=account_id)
        actions: QuerySet = ActionStore.objects.filter(post_id=post_id)
        score_post, created = ScorePost.objects.get_or_create(post=post)
        if created:
            score_post.created_at = get_ist()
        score = 0
        loved: QuerySet = actions.filter(loved=True)
        viewed: QuerySet = actions.filter(viewed=True)
        shared: QuerySet = actions.filter(shared=True)
        commented: QuerySet = actions.filter(commented=True)
        analyzer = Analyzer(account)
        weight = 0
        if loved:
            score += weights['love'] * len(loved)
            post.action_count['love'] = len(loved)
            weight = weights['love']

        if viewed:
            score += weights['view'] * len(viewed)
            post.action_count['view'] = len(viewed)
            weight = weights['view']
        if shared:
            score += weights['share'] * len(shared)
            post.action_count['share'] = len(shared)
            weight = weights['share']
        if commented:
            post.action_count['comment'] = len(commented)
        score_post.last_modified = get_ist()
        delta_date = get_ist() - post.created_at
        score_post.score = score
        freshness_score = exp(-delta_date.days)
        score_post.freshness_score = freshness_score
        score_post.net_score = score + freshness_score
        score_post.save()
        analyzer.analyze_scoreboard(post)
        analyzer.analyze(post, weight)

    def increment(self, key):
        self.post.action_count[key] += 1
        self.post.save()

    def decrement(self, key):
        if self.post.action_count[key] > 0:
            self.post.action_count[key] -= 1
        else:
            self.post.action_count[key] = 0
        self.post.save()

    def micro_action(self, action, val='', for_test: bool = False):
        weight = 0.0
        if self.user.account_id == self.post.account.account_id:
            return None
        elif action == 'comment':
            commit = self.commented(val)
        else:
            commit = self.commit_action(action)
            if not commit:
                return None
        analyzer: Analyzer = Analyzer(self.user)
        act = {}
        if 'un_love' == action:
            act['love'] = -1
        else:
            act[action] = 1
        analyzer.analyze_post_action(self.post, for_test=for_test, **act)



