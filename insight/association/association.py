from insight.models import Account, Notification
from django.db.models import Q
from insight.notifications.manager import NotificationManager
from insight.serializers import FriendListSerializer

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

    def accept_friend_request(self, target: Account):
        self.make_friend(target)

    def follow_association_manager(self, target: Account):
        if target.account_id in self.user.following:
            self.unfollow_target(target)
        else:
            self.follow_target(target)

class ManageFriends:

    def __init__(self, user: Account, is_third_party = True):
        self.user = user
        self.is_third_party = is_third_party

    def fetch_friends(self):
        friends = Account.objects.filter(friend__contains=[self.user.account_id])
        if not friends:
            return []
        serialized = FriendListSerializer(friends, user=self.user if not self.is_third_party else None)
        return serialized.render()
