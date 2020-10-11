from insight.models import *
from django.db.models import QuerySet, Q
from secrets import token_urlsafe
from datetime import timedelta

"""
    CopyRight (c) : Freaquish
    Authors: Suyash Maddhessiya, Piyush Jaiswal

"""


class CompetitionManager:

    def __init__(self, user: Account, community_id: str):
        self.user: Account = user
        self.community_id: str = community_id

    @staticmethod
    def is_tag_unique(tag):
        competition_exits: QuerySet = Competition.objects.filter(tag=tag)
        if competition_exits:
            return False
        return True

    def create_competition(self,**data):
        competition_id: str = token_urlsafe(22) + self.community_id[12:]
        if 'name' in data and 'tag' in data and 'hobbies' in data and 'competition_banner' in data:
            fields = data
            fields['competition_id'] = competition_id
            fields['start_at'] = get_ist()
            fields['end_at'] = get_ist() + timedelta(days=6)
            fields['result_date'] = get_ist() + timedelta(days=7)
            fields['is_global'] = True if fields['is_global'] == 1 else False
            fields['is_unique_post'] = True if fields['is_unique_post'] == 1 else False
            competition_exists: QuerySet = Competition.objects.filter(
                Q(tag=data['tag']) | Q(competiton_id=competition_id))
            communities: QuerySet = Community.objects.filter(
                community_id=self.community_id)
            community_members: QuerySet = CommunityMember.objects.filter(
                Q(account=self.user) & Q(community__community_id=self.community_id))
            # Checking the creator of competition ? Head or Not
            if communities and len(community_members) == 1 and len(competition_exists) == 0 and self.is_tag_unique(data['tag']):
                heads: QuerySet = community_members.filter(is_team_head=True)
                if heads and heads.first().account.account_id == self.user.account_id:
                    competition = Competition.objects.create_competition(**fields)
                    return competition
