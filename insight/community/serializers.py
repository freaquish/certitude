from rest_framework.serializers import ModelSerializer
from insight.models import Community, CommunityMember
from django.db.models import QuerySet


class CommunityCardSerializer:

    def __init__(self, communities_memberships: QuerySet):
        self.communities: QuerySet = communities_memberships

    @staticmethod
    def _serialise(community_member: CommunityMember):
        position = "Member"
        if community_member.is_team_member:
            position = "Team Member"
            if community_member.is_team_head:
                position = "Head"
        return {
            "image": community_member.community.image,
            "name": community_member.community.name,
            "tag": f"@{community_member.community.tag}",
            "position": position,
            "community_id": community_member.community.community_id
        }

    def render(self):
        return [self._serialise(community) for community in self.communities]