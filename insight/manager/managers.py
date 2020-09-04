from insight.models import Account
from django.db.models import Q
from insight.association.serializer import FriendListSerializer, FollowSerializer

class ManageFollows:

    def __init__(self, user:Account):
        self.user = user

    def fetch_followers(self):
        followers = Account.objects.filter(following__contains=[self.user.account_id])
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


