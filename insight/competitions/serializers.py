from insight.models import Competition
from insight.utils import get_ist
from django.db.models import QuerySet


class CompetitionCardSerializer:

    def __init__(self, communities_competitions: QuerySet):
        self.competitions: QuerySet = communities_competitions

    @staticmethod
    def _serialise(community_competition: Competition):
        # TODO: check this datetime to string conversion using .strftime() function
        start_at = community_competition.start_at.strftime("%d-%M-%Y, %H:%M")
        end_at = community_competition.end_at.strftime("%d-%m-%Y, %H:%M")
        result_at = community_competition.result_date.strftime("%d-%m-%Y, %H:%M")
        is_live = 0
        today = get_ist()
        if community_competition.end_at >= today:
            is_live = 1
        elif community_competition.end_at < today <= community_competition.result_date:
            is_live = 0.5
        return {
            "image": community_competition.competitions_banner,
            "name": community_competition.name,
            "tag": f"#{community_competition.tag}",
            "competition_id": community_competition.competition_id,
            "start_at": start_at,
            "end_at": end_at,
            "result_date": result_at,
            "is_live": is_live,
            "participation_closed": 0 if is_live == 1 else 1,
            "number_of_post": community_competition.number_post_submitted
        }

    def render(self):
        return [self._serialise(competition) for competition in self.competitions]
