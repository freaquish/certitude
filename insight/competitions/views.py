from json import loads as json_loads

from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from insight.competitions.main import CompetitionManager
from insight.models import Account, Competition


class CreateCompetition:
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
        if 'tag' in request.GET and CompetitionManager.is_tag_unique(request.GET['tag'].replace("#","")):
            return Response({'exist': 0}, status=status.HTTP_200_OK)
        return Response({'exist': 0}, status=status.HTTP_200_OK)

    def post(self, request):
        data = json_loads(request.body)
        user: Account = request.user
        competition_manager: CompetitionManager = CompetitionManager(user, data['community_id'])
        competition: Competition = competition_manager.create_competition(**data)
        if not competition:
            return Response({}, status=status.HTTP_406_NOT_ACCEPTABLE)
        return Response({}, status=status.HTTP_201_CREATED)


class GetCompetition(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
