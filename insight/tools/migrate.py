from insight.models import *
from django.db.models import Q, QuerySet, Count
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


def migrate_hobby_reports():
    accounts: QuerySet = Account.objects.all()
    for account in accounts.iterator():
        hobbies: QuerySet = Hobby.objects.all()
        for hobby in hobbies.iterator():
            viewed_posts: QuerySet = Post.objects.filter(Q(views__account_id=account.account_id) & Q(hobby=hobby)).count()
            loved_posts: QuerySet = Post.objects.filter(Q(loves__account_id=account.account_id) & Q(hobby=hobby)).count()
            shared_posts: QuerySet = Post.objects.filter(Q(shares__account_id=account.account_id) & Q(hobby=hobby)).count()
            commented_posts: QuerySet = Post.objects.filter(Q(comments__account=account) & Q(hobby=hobby)).count()
            if viewed_posts > 0 or loved_posts > 0 or shared_posts > 0 or commented_posts > 0:
                report, created = HobbyReport.objects.get_or_create(account=account, hobby=hobby,
                                                                    views=viewed_posts, loves=loved_posts, shares=shared_posts,
                                                                    comments=commented_posts
                                                                    )


def migrate_tags():
    posts: QuerySet = Post.objects.prefetch_related('hash_tags', 'a_tags').annotate(h_tags=Count('hash_tags'), an_tags=Count('a_tags')).filter(Q(h_tags__gt=0) | Q(an_tags__gt=0))
    for post in posts.iterator():
        for hash_tags in post.hash_tags.all():
            tag = Tags(
                tag=hash_tags.tag.replace('#', ''),
                tag_type=HASH,
                created_at=get_ist()
            )
            tag.save()
            post.hash_tags.add(tag)
        for a_tag in post.a_tags.all():
            tag = Tags(
                tag=a_tag.tag.replace('@', ''),
                tag_type=A_TAG,
                created_at=get_ist()
            )
            tag.save()
            post.a_tags.add(tag)


def sanitize_tags():
    tags: QuerySet = Tags.objects.filter(Q(tag__startswith='#') | Q(tag__startswith='@'))
    for tag in tags.iterator():
        query = {f'{"hash_tags__tag" if "#" in tag.tag else "a_tags__tag"}': tag.tag}
        posts: QuerySet = Post.objects.filter(**query)
        for post in posts.iterator():
            if '#' in tag.tag:
                post.hash_tags.remove(tag)
            else:
                post.a_tags.remove(tag)
    tags.delete()


def migrate_scoreboard():
    scoreboards: QuerySet = Scoreboard.objects.all()
    for scoreboard in scoreboards.iterator():
        scoreboard.views = scoreboard.posts.aggrgate(Count('views'))['views__count']
        scoreboard.loves = scoreboard.posts.aggrgate(Count('loves'))['loves__count']
        scoreboard.shares = scoreboard.posts.aggrgate(Count('shares'))['shares__count']
        scoreboard.save()






