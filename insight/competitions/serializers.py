from rest_framework.serializers import ModelSerializer
from insight.models import Competition
from django.db.models import QuerySet,Q
from datetime import datetime


class CompetitionCardSerializer:

    def __init__(self, communities_competitions):
        self.competitions = communities_competitions


    @staticmethod
    def _serialise(community_competition : Competition):
        TODO #check this datetime to string conversion using .strftime() function
        start_at = community_competition.start_at.strftime("%m/%d/%Y, %H:%M:%S")
        end_at = community_competition.end_at.strftime("%m/%d/%Y, %H:%M:%S")
        result_at = community_competition.result_date.strftime("%m/%d/%Y, %H:%M:%S")
        return {
            "competition_banner" : community_competition.competitions_banner,
            "name"               : community_competition.name,
            "tag"                : f"#{community_comppetition.tag}",
            "competition_id"     : community_competition.competition_id,
            "start_at"           : start_at,
            "end_at"             : end_at,
            "result_date"        : result_at,
            TODO #Check this line correct or not ???  
            "is_live"            : 1 if Competition.objects.filter(Q(start_at__gte=get_ist()), Q(end_at__lte=get_ist())) else 0,
        }


    def render(self):
        return [self._serialise(competition) for competition in self.competitions]