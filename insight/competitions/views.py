from rest_framework import status
from rest_framework.views import APIView
from insight.leaderboard.main import *
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authentication import TokenAuthentication
from insight.competitions.main import CompetitionManager
from rest_framework.decorators import api_view, permission_classes
from rest_framework.reverse import reverse_lazy
from insight.models import *

import json


class CompetitionView(APIView):
    """
    Returns data of Competition according to user
    Structure:
      Tabs: tabs along with redirect urls
      Default Tab: tab name automatically selected
                  :: If user has participated or host will directly see feeds else About
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [AllowAny]


class CreateCompetition(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        data = json.loads(request.body)
        user: Account = request.user
        manager: CompetitionManager = CompetitionManager(user)
        response: Response = None
        try:
            competition: Competition = manager.create(**data)
            response = Response({})
        except Exception as e:
            response = Response({"msg": e}, status=status.HTTP_406_NOT_ACCEPTABLE)


