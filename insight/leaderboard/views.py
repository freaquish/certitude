from rest_framework import status
from rest_framework.views import APIView
from insight.leaderboard.main import *
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
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
        hobbies_from_db = Hobby.objects.all()
        if 'hobbies' in request.GET:
            hobbies = request.GET['hobbies'].split('+')
            hobby = hobbies[0]
        else:
            hobby = user.primary_hobby
        # print(user.hobby_map)
        leaderboard = LeaderBoardEngine(user=user, hobby=hobby)
        selected_hobby = hobbies_from_db.filter(code_name=hobby)
        if selected_hobby:
            selected_hobby = selected_hobby.first()
            serialise_selected_hobby = HobbySerializer(selected_hobby).data
        else:
            serialise_selected_hobby = {}
        serialise_hobby_from_db = HobbySerializer(hobbies_from_db, many=True)
        ranked_hobby_users = leaderboard.hobby_rank_global()
        return Response({"hobbies": serialise_hobby_from_db.data, "selected": serialise_selected_hobby,
                         "users": ranked_hobby_users}, status=status.HTTP_200_OK)
