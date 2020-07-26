from django.db.models.fields import DecimalField
from insight.utils import get_ist_date
from django.db.models import F, Q
import datetime
from insight.models import Account, Post, UserActionRef, Hobby


class Feed:

    def __init__(self, *account):
        if account:
            self.account: Account = account[0]

    """
     Goal: Fetch all the post viewed and posted by friends and following and also all the primary hobby with high score
      than fetch all the posts with hobbies present in hobby_map and nearest hobby post which is not covered already.
      from_friend = 0.96
      from_following = 0.82
      influencer = 0.85
      feed_weight = reference * score*10 + (1  - abs(diff_weight_hobby) *<hit | nearest_hobby_in_maps_hit>)
      
    """
    def extract_feed_known(self):
        hobby_map = self.account.hobby_map
        hobbies = {hobby.code_name: hobby.weight for hobby in Hobby.objects.all()}
        buffer_date = get_ist_date() - datetime.timedelta(days=3)
        query = None
        hobby_query = None

        # Gathering all posts and nearby posts of all hobbies
        for hobby in hobby_map:
            if not hobby_query:
                hobby_query = Q(Q(weight__gte=hobbies[hobby]) & Q(weight__lte=hobbies[hobby]))
            else:
                hobby_query = hobby_query | Q(Q(weight__gte=hobbies[hobby] - 1) & Q(weight__lt=hobbies[hobby] + 1.25))

        # Gathering all post of friends
        for friend in self.account.friend:
            if not query:
                query = Q(account_id=friend)
            else:
                query = query | Q(account_id=friend)

        # Gathering all post of following
        for follow in self.account.following:
            if not query:
                query = Q(account_id=follow)
            else:
                query = query | Q(account_id=follow)

        # Retreive all the actions within 4 days
        actions = UserActionRef.objects.filter(Q(account_id=self.account.account_id) & Q(date_created__gte=buffer_date))
        views = []
        for action in actions:
            views = views + action.views

        # Making sure no viewed post should come up
        viewed_query = None
        for viewed_post in views:
            if not viewed_query:
                viewed_query = ~Q(post_id=viewed_post)
            else:
                viewed_query = viewed_query | ~Q(post_id=viewed_post)

        # Adding all the queries
        final_query: Q = Q(query & hobby_query & viewed_query)
        posts = Post.objects.filter(final_query).annotate(
            feed_weight=DecimalField(F('score')*10 + ((1 + (F('hobby_weight') - self.account.primary_weight)
                                                       ) * (hobby_map[F('hobby')] if F('hobby') in hobby_map else 1))
                                     )).order_by('-created_at', 'feed_weight',)
        return posts

    @staticmethod
    def feed_anonymous():
        buffer_date = get_ist_date() - datetime.timedelta(days=4)
        posts = Post.objects.filter(Q(created_at__gte=buffer_date)).order_by('score', '-created_at')
        return posts










