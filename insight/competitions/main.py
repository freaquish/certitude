from insight.models import *
from django.db.models import QuerySet, Q
from secrets import token_urlsafe

"""
    CopyRight (c) : Freaquish
    Authors: Suyash Maddhessiya, Piyush Jaiswal

"""


class CompetitionManager:


    def __init__(self, user: Account, community_id: Community):
        self.user: Account = user
        self.community_id = community_id


    @staticmethod
    def if_tag_exits(tag):
        competiton_exits: QuerySet = Competitions.object.filter(tag=tag)
        if competiton_exits:
            return False

        return True

# creating Comppetition
    def create_competition(self, member_id, community_id,**data):
        competiton_id: str = token_urlsafe(22) + self.community_id[12:]
        if 'name' in data and 'tag' in data and 'hobbies' in data and 'competition_banner' in data:
            fields = data
            fields['competition_id'] = competiton_id
            fields['start_at'] = get_ist()
            fields['end_at'] = get_ist()
            competiton_exits : QuerySet = Competitions.objects.filter(Q(tag=data['tag']) | Q(competiton_id=competiton_id))
            communities: QuerySet = Community.objects.filter(community_id=community_id)
            community_members: QuerySet = CommunityMember.objects.filter(\
                                                                        Q(Q(account=self.user) | Q(account__account_id=member_id)) & Q(community_id=community_id))
            """Checking the creator of competition ??? Head or Not """
            if communities and len(community_members) == 2:
                heads : QuerySet = community_members.filter(is_team_head = True)
                if heads:
                    competition = Competitions.objects.create_competition(**fields)

                    return competition