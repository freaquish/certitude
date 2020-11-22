from insight.models import Account
from django.db.models import Q
from insight.association.serializer import FriendListSerializer, FollowSerializer

# TODO: Migrate Friends and Followers on models based view
"""
 Author: Piyush Jaiswal and Suyash Maddhessiya
"""


class AssociationEngine:

    def __init__(self, user):
        self.user = user

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
