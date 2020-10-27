from insight.models import Post,  Tags, Community, CommunityPost, Competition, CompetitionPost, CommunityMember
from insight.utils import get_ist
from django.db.models import Q, QuerySet


class PostCreationManager:
    def __init__(self, post: Post, **kwargs):
        self.post: Post = post
        self.kwargs = kwargs

    def catch(self):
        self.create_tag()

    def create_tag(self):
        all_tags = self.post.hastags + self.post.atags
        if all_tags:
            tag_query = None
            for tag in all_tags:
                if tag_query:
                    tag_query = tag_query | Q(tag=tag)
                else:
                    tag_query = Q(tag=tag)
            if tag_query:
                tags_present_in_db = Tags.objects.filter(tag_query).values_list('tag', flat=True)
                if len(all_tags) != len(tags_present_in_db):
                    tags_not_in_db = set(all_tags).difference(tags_present_in_db)
                    if len(tags_not_in_db) > 0:
                        tags: QuerySet = Tags.objects.bulk_create(
                            [Tags(tag=tag_name, created_at=get_ist(), first_used=self.post.post_id) for tag_name in
                             tags_not_in_db])

            self.attach_to_community()

    def attach_to_community(self):
        query = None
        for tag in self.post.atags:
            if query:
                query = query | Q(tag=tag.replace('@', ''))
            else:
                query = Q(tag=tag.replace('@', ''))
        if query:
            communities = Community.objects.filter(query)
            user_related_communities: QuerySet = CommunityMember.objects.filter(account__account_id=self.post.account.account_id)
            for community in communities:
                if user_related_communities.filter(community=community).exists():
                    community_post: CommunityPost = CommunityPost.objects.create(post=self.post, community=community,
                                                                                 created_at=get_ist())

    def attach_to_competition(self):
        query = None
        for tag in self.post.hastags:
            if query:
                query = query | Q(tag=tag.replace('#', ''))
            else:
                query = Q(tag=tag.replace('#', ''))
        if not query:
            return None
        competitions: QuerySet = Competition.objects.filter(query)
        if not competitions:
            return None
        post_submitted_by_user = CompetitionPost.objects.filter(post__account=self.post.account)
        users_community: QuerySet = CommunityMember.objects.filter(account=self.post.account)
        community_post: QuerySet = CommunityPost.objects.filter(post=self.post)
        creatable_competition_post = []
        creatable_community_post = []
        for competition in competitions:
            if competition.end_at >= get_ist() and self.post.hobby.code_name in competition.hobbies and \
                    not post_submitted_by_user.filter(post=self.post).exists():
                if not competition.is_global and not users_community.filter(community=competition.community).exists():
                    continue
                elif competition.is_unique_post and len(competitions) > 1:
                    continue
                creatable_competition_post.append(CompetitionPost(post=self.post, competition=competition, created_at=get_ist()))
                if not community_post.filter(community=competition.community):
                    creatable_community_post.append(CommunityPost(community=competition.community, post=self.post, created_at=get_ist()))
        CommunityPost.objects.bulk_create(creatable_community_post)
        CompetitionPost.objects.bulk_create(creatable_competition_post)



