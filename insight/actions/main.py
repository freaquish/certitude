from insight.models import Post, ActionStore, Account
from celery import shared_task
from django.db.models import QuerySet
from insight.utils import get_ist
from math import log


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

    def commit_action(self, action):
        if action == 'viewed' and self.post.account.account_id == self.user.account_id:
            return False
        action_store, created = ActionStore.objects.get_or_create(
            account_id=self.user.account_id, post_id=self.post.post_id
        )
        if action == 'viewed' and action_store.viewed:
            return False
        elif action == 'viewed' and not action_store.viewed:
            action_store.viewed = True
            action_store.viewed_at = get_ist()
        elif action == 'loved':
            action_store.loved = not action_store.loved
            action_store.loved_at = get_ist()
        elif action == 'shared':
            action_store.shared = True
        elif action == 'commented':
            action_store.commented = True
        action_store.save()
        return True

    @staticmethod
    @shared_task
    def score_post(post_id: str):
        posts: QuerySet = Post.objects.filter(post_id=post_id)
        if not posts:
            return None
        post: Post = posts.first()
        actions: QuerySet = ActionStore.objects.filter(post_id=post_id)
        score = 0
        loved: QuerySet = actions.filter(loved=True)
        viewed: QuerySet = actions.filter(viewed=True)
        shared: QuerySet = actions.filter(shared=True)
        commented: QuerySet = actions.filter(commented=True)
        if loved:
            score += weights['love'] * len(loved)
            post.action_count['love'] = len(loved)
        if viewed:
            score += weights['view'] * len(viewed)
            post.action_count['view'] = len(viewed)
        if shared:
            score += weights['share'] * len(shared)
            post.action_count['share'] = len(shared)
        if commented:
            post.action_count['comment'] = len(commented)

        delta_date = get_ist() - post.created_at
        freshness_score = log(delta_date.days) if delta_date.days > 0 else log(0.01)
