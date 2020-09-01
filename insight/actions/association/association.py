from insight.models import Account
from insight.models import Notification


class AssociationEngine:
     
    def __init__(self,user):
        self.user = user


    def make_friend(self,target):
        target.friend.append(self.user.account_id)
        self.user.friend.append(target.account_id)
        self.user.friend_count += 1
        target.friend_count += 1
        target.save()
        self.user.save()



    def remove_friend(self,target):
        target.friend.remove(self.user.account_id)
        self.user.friend.remove(target.account_id)
        self.user.friend_count -= 1
        target.friend_count -= 1
        target.save()
        self.user.save()


    def follow_friend(self, target):
        target.following.append(self.user.account_id)
        target.following_count += 1
        self.user.follower_count += 1
        target.save()
        self.user.save()

    def unfollow_friend(self, target):
        target.following.remove(self.user.account_id)
        target.following_count -= 1
        self.user.follower_count -= 1
        target.save()
        self.user.save()



