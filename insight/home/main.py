from insight.models import Post, Account, UserPostComment, LoveActionModel, ViewActionModel, ShareActionModel
from insight.utils import get_ist
from insight.workers.analyzer import Analyzer

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
            return self.commit_action('comment', user_comment=comment)

    """
    Serious Improvement required, suppose user base grown to 10 million and 5 million post
    recorded 1000 home each, then 1000 * 5 million
    total stores = 5000000000 stores
    select query will be extremely slow, we need to index the account_id and post_id
    needed to introduce some serious arch.
    I think in the coming age all of the backend should be re-written
    
    The write should be in go
    """
    def commit_action(self, action, user_comment: UserPostComment = None):
        if action == 'viewed':
            return False
        elif action == 'comment' and user_comment:
            self.post.comments.add(user_comment)
        else:
            self.post.add(f'{action}s', self.user)
        return True

    def micro_action(self, action, val='', for_test: bool = False):
        weight = 0.0
        if self.user.account_id == self.post.account.account_id and action != 'comment':
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



