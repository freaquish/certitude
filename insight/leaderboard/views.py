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
      For instance hobbies is the only keyword sent, later need to add users communities, places, competitions and q for unkonwn
    """
    def get(self, request):
        user: Account = request.user
        leaderboard = LeaderboardEngine(user=user)
        hobby = None
        scoreboards = []
        if 'hobby' in request.GET:
            hobby = request.GET['hobby']
            scoreboards = leaderboard.hobby_rank_global(hobby=hobby)
        else:
            scoreboards = leaderboard.hobby_rank_global()
        if 'search' in request.GET:
            scoreboards = leaderboard.find_users_in_queryset(scoreboards, user_string=request.GET['search'])

        if 'sort' in request.GET:
            if request.GET['sort'] == 'loves':
                scoreboards = leaderboard.sort_by_love(scoreboards)
            elif request.GET['sort'] == 'views':
                scoreboards = leaderboard.sort_by_view(scoreboards)
        serialise_hobby = {}
        if 'no_hobby' not in request.GET:
            hobbies = Hobby.objects.all()
            serialise_hobby = HobbySerializer(hobbies, many=True).data

        # TODO: Paginator in second edition
        scoreboards = leaderboard.slice(scoreboards, 50)
        serialized_scoreboards = [leaderboard.serialize_hobby_rank(scoreboard, index, hobby=hobby) for index, scoreboard in enumerate(scoreboards)]
        self_score = {}
        for index, scoreboard in enumerate(scoreboards):
            score_card = leaderboard.serialize_hobby_rank(scoreboard, index, hobby=hobby)
            if scoreboard.account.account_id == user.account_id:
                self_score = score_card.copy()
            serialized_scoreboards.append(score_card)
        return Response({"hobbies": serialise_hobby, "scoreboards": serialized_scoreboards,
                         "self": self_score}, status=status.HTTP_200_OK)
