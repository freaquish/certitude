from insight.models import Account, Post, Hobby, RankBadge
from insight.utils import *
from django.db.models import Q, QuerySet

"""
@PyDoc



Ranking managment class, responsible of ranking posts in each hobby by composite ranking analogy,
and user ranking analogy.

@Composite Ranking : Ranking of user in each hobby
@Affirmative Ranking : Ranking of post in each hobby


"""


class RankingEngine:
    def __init__(self):
        pass

    """
     Running through hobbies sorting all posts and ranking them according to index
    """

    def weekly_ranking(self):
        hobbies = Hobby.objects.all()
        now = get_ist()
        for hobby in hobbies:
            posts = Post.objects.filter(Q(hobby=hobby) & Q(
                created_at__gte=get_time_delta(now, days=7)))
            ranked_posts = self.rank_posts(posts)

    def rank_posts(self, posts: QuerySet):
        # Using django ranking
        sorted_posts = posts.order_by('score')
        for index in range(len(sorted_posts)):
            sorted_posts[index].rank = index + 1
            sorted_posts[index].save()
        return sorted_posts

    def composite_ranking(self, hobby: Hobby, posts: QuerySet, competition_name='Weekly Competition'):
        # cummulate all users posted in given hobby
        # create a dict with account_id:@key and total_score/total_post: @value
        # sort the dict and create rank badge
        users_score_dict = {}
        for post in posts:
            if post.account.account_id in users_score_dict:
                users_score_dict[post.account.account_id] += post.score
            else:
                users_score_dict[post.account.account_id] = post.score
        sorted_values = sorted(users_score_dict.items(),
                               key=lambda item: item[1], reverse=True)
        total_users = len(users_score_dict)
        badges = []
        for index in range(total_users):
            badges.append(RankBadge(created_at=get_ist(),
                                    competition_name=competition_name,
                                    account=Account.objects.get(
                                        pk=sorted_values[index][0]),
                                    score=sorted_values[index][1],
                                    rank=index + 1,
                                    total=total_users,
                                    hobby=hobby
                                    ))
        ranks = RankBadge.objects.bulk_create(badges)
