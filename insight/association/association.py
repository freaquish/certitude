from insight.models import Account, Notification
from django.db.models import Q
from insight.notifications.manager import NotificationManager


class AssociationEngine:

    def __init__(self, user):
        self.user = user

    def make_friend(self, target: Account):
        target.friend.append(self.user.account_id)
        self.user.friend.append(target.account_id)
        self.user.friend_count += 1
        target.friend_count += 1
        target.save()
        self.user.save()

    def remove_friend(self, target: Account):
        target.friend.remove(self.user.account_id)
        self.user.friend.remove(target.account_id)
        self.user.friend_count -= 1
        target.friend_count -= 1
        target.save()
        self.user.save()

    def follow_target(self, target: Account):
        target.following.append(self.user.account_id)
        target.following_count += 1
        self.user.follower_count += 1
        target.save()
        self.user.save()

    def unfollow_target(self, target: Account):
        target.following.remove(self.user.account_id)
        target.following_count -= 1
        self.user.follower_count -= 1
        target.save()
        self.user.save()

    def friend_association_manager(self, target: Account):
        if target.account_id in self.user.friend:
            self.remove_friend(target)
        else:
            notifications = Notification.objects.filter(
                Q(to=target) & Q(Q(header=self.user.username) & Q(type='REQU')))
            if not notifications:
                notification_manager = NotificationManager()
                notification_manager.create_friend_request(
                    to=target, from_=self.user)

    def accept_friend_request(self, noti: str):
        notifications = Notification.objects.filter(noti_id=noti)
        if notifications:
            notification = notifications.first()
            notification.read = True
            notification.save()
            self.make_friend(self.user)

    def follow_association_manager(self, target: Account):
        if target.account_id in self.user.following:
            self.unfollow_target(target)
        else:
            self.follow_target(target)
