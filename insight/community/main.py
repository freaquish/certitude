from insight.models import *
from django.db.models import QuerySet, Q
from secrets import token_urlsafe


class CommunityManager:

    def __init__(self, user: Account):
        self.user: Account = user

    def create(self, **data):
        community_id: str = token_urlsafe(16) + self.user.account_id[6:]
        if 'name' in data and 'tag' in data and 'hobbies' in data and 'image' in data:
            fields = data
            fields['community_id'] = community_id
            fields['created_at'] = get_ist()
            community = Community.objects.create(**fields)
            return community

    def edit(self, community_id, **data):
        communities: QuerySet = Community.objects.filter(community_id=community_id)
        community_members: QuerySet = CommunityMember.objects.filter(
            Q(Q(account__account_id=self.user.account_id) &
              Q(community_id=community_id)) & Q(is_team_member=True))
        if communities and community_members:
            community = communities.first()
            community.edit(**data)

    def join(self, community_id, **meta):
        communities: QuerySet = Community.objects.filter(community_id=community_id)
        community_members: QuerySet = CommunityMember.objects.filter(
            Q(account__account_id=self.user.account_id) &
            Q(community_id=community_id))
        if communities and len(community_members) == 0:
            community_member = CommunityMember.objects.create(created_at=get_ist(),
                                                              community_id=community_id, account=self.user,
                                                              is_team_member=False, is_team_head=False)
            if 'is_head' in meta and meta['is_head'] == 1:
                community_member.is_team_head = True
                community_member.save()
                team_members = TeamMember.objects.filter(Q(account=self.user) & Q(community_id=community_id))
                if len(team_members) == 0:
                    team_member = TeamMember.objects.create(account=self.user, position='Head',
                                                            is_head=True, assigned_at=get_ist())

    def include_member_in_team(self, community_id, member_id):
        communities: QuerySet = Community.objects.filter(community_id=community_id)
        community_members: QuerySet = CommunityMember.objects.filter(
            Q(account=self.user) | Q(account__account_id=member_id))
        if communities and len(community_members) == 2:
            community = communities.first()
            head: QuerySet = community_members.filter(is_team_head=True)
            member: QuerySet = community_members.filter(is_team_member=False)
            if head and member:
                head: CommunityMember = head.first()
                member: CommunityMember = member.first()
                team_member = TeamMember.objects.filter(
                    account=member.account, assigned_at=get_ist(), position='Member',
                    is_head=False, community_id=community_id
                )

    def edit_team_data(self, community_id, **change):
        team_members: QuerySet = TeamMember.objects.filter(Q(account=self.user) & Q(community_id=community_id))
        if team_members:
            team_member: TeamMember = team_members.first()
            if team_member.account == self.user:
                meta = {}
                if 'position' in change and change['position'].lower() != 'head':
                    meta['position'] = change['position']
                if 'description' in change:
                    meta['description'] = change['description']
                if len(meta) > 0:
                    team_member.edit(**meta)

    def remove_team_member(self, community_id, member_id):
        team_members: QuerySet = TeamMember.objects.filter(Q(account=self.user) & Q(account__account_id=member_id))
        pass
            
