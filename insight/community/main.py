from insight.models import *
from django.db.models import QuerySet, Q
from secrets import token_urlsafe

"""
Copyright (c) : freaquish
Authors: Piyush Jaiswal, Suyash Maddhessiya


"""


class CommunityManager:

    def __init__(self, user: Account):
        self.user: Account = user

    @staticmethod
    def tag_exist(tag: str):
        community_exist: QuerySet = Community.objects.filter(tag=tag)
        account_exist: QuerySet = Account.objects.filter(username=tag)
        if community_exist or account_exist:
            return False
        return True

    def create(self, **data):
        community_id: str = token_urlsafe(16) + self.user.account_id[6:]
        if 'name' in data and 'tag' in data and 'hobbies' in data and 'image' in data:
            fields = data
            fields['community_id'] = community_id
            fields['created_at'] = get_ist()
            community_exist: QuerySet = Community.objects.filter(Q(tag=data['tag']) | Q(community_id=community_id))
            community = Community.objects.create(**fields)
            # creating community member
            community_member: CommunityMember = CommunityMember.objects.create(
                created_at=get_ist(), community_id=community.community_id, account=self.user,
                is_team_member=True, is_team_head=True
            )
            team_member: TeamMember = TeamMember.objects.create(
                account=self.user, assigned_at=get_ist(), position='Head',
                description='Head and Creator of Community', is_head=True, community_id=community.community_id
            )
            return community

    def edit(self, community_id, **data):
        communities: QuerySet = Community.objects.filter(community_id=community_id)
        community_members: QuerySet = CommunityMember.objects.filter(
            Q(Q(account__account_id=self.user.account_id) &
              Q(community_id=community_id)) & Q(is_team_member=True))
        if communities and community_members:
            community = communities.first()
            if 'tag' in data and data['tag'] != community.tag:
                tag_exist: bool = self.tag_exist(data['tag'])
                if not tag_exist:
                    return None
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

    def include_member_in_team(self, community_id, member_id):
        communities: QuerySet = Community.objects.filter(community_id=community_id)
        community_members: QuerySet = CommunityMember.objects.filter(
            Q(Q(account=self.user) | Q(account__account_id=member_id)) & Q(community_id=community_id))
        if communities and len(community_members) == 2:
            community = communities.first()
            heads: QuerySet = community_members.filter(is_team_head=True)
            members: QuerySet = community_members.filter(is_team_member=False)
            if heads and members:
                head: CommunityMember = heads.first()
                member: CommunityMember = members.first()
                if head.is_team_head and head == self.user:
                    team_member = TeamMember.objects.filter(
                        account=member.account, assigned_at=get_ist(), position='Member',
                        is_head=False, community_id=community_id
                    )
                    member.is_team_member = True
                    member.save()

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
        team_members: QuerySet = TeamMember.objects.filter(Q(Q(account=self.user) | Q(account__account_id=member_id)) & Q(community_id=community_id))
        if team_members:
            heads: QuerySet = team_members.filter(is_head=True)
            members: QuerySet = team_members.filter(is_head=False)
            if heads and members:
                head: TeamMember = heads.first()
                member: TeamMember = members.first()
                if head == self.user:
                    member.delete()
                    community_members: QuerySet = CommunityMember.objects.filter(Q(account__account_id=member_id) & Q(community_id=community_id))
                    if community_members:
                        community_member: CommunityMember = community_members.first()
                        community_member.is_team_member = False
                        community_member.save()

    def leave_community(self, community_id):
        community_members: QuerySet = CommunityMember.objects.filter(Q(account=self.user) & Q(community_id=community_id))
        if community_members:
            community_member: CommunityMember = community_members.first()
            if community_member.is_team_member:
                team_members: QuerySet = TeamMember.objects.filter(Q(account=self.user) & Q(community_id=community_id))
                if team_members:
                    team_member: TeamMember = team_members.first()
                    if team_member.account.account_id == self.user.account_id:
                        team_member.delete()
            community_member.delete()





            
