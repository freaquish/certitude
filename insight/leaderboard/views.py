from rest_framework import status
from rest_framework.views import APIView
from insight.leaderboard.main import *
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from insight.leaderboard.main import LeaderboardEngine
from rest_framework.authentication import TokenAuthentication
from insight.serializers import HobbySerializer


class LeaderboardView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    """
      also sends hobbies
      Working of this view is based on keyword based comparing
      For instance hobbies is the only keyword sent, later need to add users communities, places, competitions and q for unknown
    """
    def get(self, request):
        user: Account = request.user
        leaderboard = LeaderboardEngine(user=user)
        hobby = None
        scoreboards = []
        sort = 'net_score'
        if 'sort' in request.GET:
            sort = request.GET['sort']
        hobby = None
        if 'hobby' in request.GET and request.GET['hobby'] != 'all':
            hobby = request.GET['hobby']
        scoreboards = leaderboard.hobby_rank_global(hobby=hobby, sort=sort)
        serialise_hobby = {}
        if 'no_hobby' not in request.GET:
            hobbies = Hobby.objects.filter(last_scoreboard__gte=get_ist())
            serialise_hobby = HobbySerializer(hobbies, many=True).data
        if 'search' in request.GET:
            serialised_scoreboards = leaderboard.get_ranked_user(scoreboards, user_string=request.GET['search'])
            return Response({"hobbies": serialise_hobby, "scoreboards": serialised_scoreboards}, status=status.HTTP_200_OK)

        # TODO: Paginator in second edition
        serialized_scoreboards = []
        for index, scoreboard in enumerate(scoreboards):
            score_card = leaderboard.serialize_hobby_rank(scoreboard, index, hobby=hobby)
            serialized_scoreboards.append(score_card)
        return Response({"hobbies": serialise_hobby, "scoreboards": serialized_scoreboards}, status=status.HTTP_200_OK)
