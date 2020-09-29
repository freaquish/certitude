from insight.models import Account, Notification
from django.db.models import Q
from insight.notifications.manager import NotificationManager
from insight.association.serializer import FriendListSerializer, FollowSerializer

#TODO: Migrate Friends and Followers on models based view

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
        if target.account_id in self.user.following:
            return None 
        self.user.following.append(target.account_id)
        self.user.following_count += 1
        target.follower_count += 1
        target.save()
        self.user.save()

    def unfollow_target(self, target: Account):
        self.user.following.remove(target.account_id)
        self.user.following_count -= 1
        target.follower_count -= 1
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
        if target.account_id == self.user.account_id:
            return None
        if target.account_id in self.user.following:
            self.unfollow_target(target)
        else:
            self.follow_target(target)


class ManageFriends:

    def __init__(self, user: Account, is_third_party=True):
        self.user = user
        self.is_third_party = is_third_party

    def fetch_friends(self):
        friends = Account.objects.filter(
            friend__contains=[self.user.account_id])
        if not friends:
            return []
        serialized = FriendListSerializer(
            friends, user=self.user if not self.is_third_party else None)
        return serialized.render()


class ManageFollows:

    def __init__(self, user: Account):
        self.user = user

    def fetch_followers(self):
        followers = Account.objects.filter(
            following__contains=[self.user.account_id])
        if not followers:
            return []
        serialized = FollowSerializer(followers)
        return serialized.render()

    def fetch_followings(self):
        query = None
        following = self.user.following
        for follow in following:
            if not query:
                query = Q(account_id=follow)
            else:
                query = query | Q(account_id=follow)

        if not query:
            return []
        following = Account.objects.filter(query)
        serialized = FollowSerializer(following)
        return serialized.render()
