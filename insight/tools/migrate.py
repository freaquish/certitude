from insight.models import *
from django.db.models import Q, QuerySet
from insight.workers.analyzer import Analyzer


def migrate_posts():
    posts: QuerySet = Post.objects.all()
    action_stores: QuerySet = ActionStore.objects.all()
    for post in posts.iterator():
        v_stores: QuerySet = action_stores.filter(Q(post_id=post.post_id) & Q(viewed=True)).values_list('account_id',
                                                                                                        flat=True)
        l_stores: QuerySet = action_stores.filter(Q(post_id=post.post_id) & Q(loved=True)).values_list('account_id',
                                                                                                       flat=True)
        s_stores: QuerySet = action_stores.filter(Q(post_id=post.post_id) & Q(shared=True)).values_list('account_id',
                                                                                                        flat=True)
        comments: QuerySet = UserPostComment.objects.filter(post_id=post.post_id)

        a_tags: QuerySet = Tags.objects.filter(tag__in=post.atags)
        hash_tags: QuerySet = Tags.objects.filter(tag__in=post.hastags)

        post.a_tags.set(a_tags)
        post.hash_tags.set(hash_tags)

        post.views.set(Account.objects.filter(account_id__in=v_stores))
        post.loves.set(Account.objects.filter(account_id__in=l_stores))
        post.shares.set(Account.objects.filter(account_id__in=s_stores))
        post.comments.set(comments)
        post.freshness_score = Analyzer.calculate_freshness_score(post)
        post.score = Analyzer(user=None).score_post(
            {'view': post.views.count(), 'love': post.loves.count(), 'share': post.shares.count()})
        post.net_score = post.freshness_score + post.score
        post.save()



