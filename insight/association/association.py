from insight.models import Account
from insight.notifications.manager import NotificationManager


class AssociationEngine:

    def __init__(self, user):
        self.user = user

    def make_friend(self, target):
        target.friend.append(self.user.account_id)
        self.user.friend.append(target.account_id)
        self.user.friend_count += 1
        target.friend_count += 1
        target.save()
        self.user.save()

    def remove_friend(self, target):
        target.friend.remove(self.user.account_id)
        self.user.friend.remove(target.account_id)
        self.user.friend_count -= 1
        target.friend_count -= 1
        target.save()
        self.user.save()

    def follow_target(self, target):
        target.following.append(self.user.account_id)
        target.following_count += 1
        self.user.follower_count += 1
        target.save()
        self.user.save()

    def unfollow_target(self, target):
        target.following.remove(self.user.account_id)
        target.following_count -= 1
        self.user.follower_count -= 1
        target.save()
        self.user.save()

    def friend_association_manager(self, target):
        if target.account_id in self.user.friend:
            self.remove_friend(target)
        else:
            self.make_friend(target)
            notification_manager = NotificationManager()
            notification_manager.create_friend_request(target, self.user)

    def follow_association(self, target):
        if target.account_id in self.user.following:
            self.unfollow_target(target)
        else:
            self.follow_target(target)
