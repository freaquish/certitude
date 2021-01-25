from insight.models import Post, Account, UserPostComment, LoveActionModel, ViewActionModel, ShareActionModel
from insight.utils import get_ist
from insight.workers.analyzer import Analyzer
from insight.notifications.notifications import NotificationManager
from enum import Enum

weights = {
    'love': 0.50,
    'view': 0.15,
    'share': 0.65,
    'save': 0.60
}


class Actions(Enum):
    Love = 'love'
    Un_love = 'un_love'
    View = 'view'
    Share = 'share'
    Up_vote = 'up_vote'
    Down_vote = 'down_vote'
    Comment = 'comment'


class PostActions:
    def __init__(self, user: Account, post: Post):
        self.user: Account = user
        self.post: Post = post
        self.notification_manager = NotificationManager(user)

    def commented(self, value):
        if self.user:
            comment = UserPostComment.objects.create(
                post_id=self.post.post_id, account=self.user, created_at=get_ist(), comment=value)
            return self.commit_action('comment', user_comment=comment)

    def create_notification(self, body: str, intent: str = '', intent_param: str = ''):
        self.notification_manager.insert_notification(self.post.account,
            {
                "body": body,
                "intent": intent,
                "intent_param": intent_param
            }
        )

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
        body = ''
        intent = 'one_post'
        intent_param = self.post.post_id
        if action == 'viewed':
            return False
        elif action == 'comment' and user_comment:
            # print('Using this comment api')
            self.post.comments.add(user_comment)
            text = user_comment.comment if len(user_comment.comment) < 20 else f"{user_comment.comment[:20]}.."
            body = f'<strong>{self.user.username}</strong> has commented <strong>{text}</strong> on your post'
        elif isinstance(self.user, Account):
            # print(action == 'un_love', 'action')
            if action == 'love' or action == 'un_love':
                act = self.post.love_add(self.user.account_id)
                body = f"<strong>{self.user.username}</strong> {'hated' if action == 'un_love' else 'loved'} your post"
            elif action == 'view':
                act = self.post.view_add(self.user.account_id)
                # body = f"{self.user.username} {'hated' if action == 'un_love' else 'loved'} your post"
            elif action == 'share':
                act = self.post.share_add(self.user.account_id)
                body = f"<strong>{self.user.username}</strong> loved it so much that he shared your post"
        self.create_notification(body, intent_param=intent_param, intent=intent)
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



