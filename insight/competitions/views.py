from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authentication import TokenAuthentication
from insight.competitions.main import *
from rest_framework.generics import GenericAPIView
from insight.models import *
from insight.paginator import CompetitionFeedPaginator
from insight.competitions.serializers import *

import json


class CompetitionChecks(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        response: Response = Response({}, status=status.HTTP_400_BAD_REQUEST)
        if "tag" in request.GET:
            tags: QuerySet = Tags.objects.filter(tag=request.GET['tag'])
            response = Response({"exist": 1 if tags.exists() else 0}, status=status.HTTP_200_OK)
        return response


class CompetitionView(GenericAPIView):
    """
    Returns data of Competition according to user
    Structure:
      Tabs: tabs along with redirect urls
      Default Tab: tab name automatically selected
                  :: If user has participated or host will directly see feeds else About
    """
    authentication_classes = [TokenAuthentication]
    permission_classes = [AllowAny]
    queryset = None
    serializer_class = PostSerializer
    pagination_class = CompetitionFeedPaginator

    def get(self, request, tag):
        """
        Competition view will provide view of full competition
        If no tab is sent then view will decide which tab to send
        otherwise the respective tab will be used
        """
        user = request.user
        data = request.GET
        try:
            manager: CompetitionManager = CompetitionManager(user)
            competition_response: CompetitionResponse = manager.view(tag, **data)
            if competition_response["current_tab"] == "Leaderboard":
                self.serializer_class = CompetitionLeaderboardSerializer
            response = Response({}, status=status.HTTP_404_NOT_FOUND)
            if competition_response["current_tab"] == "About":
                response = Response(competition_response.dump(), status=status.HTTP_200_OK)
            else:
                # Implement Leaderboard view using If else statement
                page = self.paginate_queryset(competition_response["body"])
                if page is None:
                    serialized = self.serializer_class(competition_response["body"], user=user)
                    competition_response["body"] = serialized.render()
                    response = Response(competition_response.dump(), status=status.HTTP_200_OK)
                else:
                    serialized = self.serializer_class(page, user=user)
                    response = self.get_paginated_response(serialized.render())
            return response
        except Exception as e:
            return Response({}, status=status.HTTP_404_NOT_FOUND)


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
            response = Response({}, status=status.HTTP_201_CREATED)
        except Exception as e:
            response = Response({"msg": e}, status=status.HTTP_406_NOT_ACCEPTABLE)
        return response


class CompetitionSearch(APIView):
    """
    API Endpoint to search competition using tag, hobby, dates and host
    This API will also be used to ensure that User couldn't override the competition-hobby pair
    i.e no user can search out of bound competitions, when creating post user can inquire competition
    which doesn't belong to post's hobby
    """

    search_manager_class = CompetitionSearch
    serializer_class = CompetitionSearchSerializer

    def get(self, request) -> Response:
        # TODO: Implement Paginator
        data: dict = request.GET
        search_manager = self.search_manager_class(request.user, **data)
        competitions: QuerySet = search_manager.competition_filter()
        serializer = self.serializer_class(competitions, user=request.user)
        return Response({"data": serializer.render()}, status=status.HTTP_200_OK)




