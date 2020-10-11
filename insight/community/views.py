from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from json import loads as json_loads
from django.db.models import Q, QuerySet

from insight.models import Account, Community, CommunityMember
from insight.community.main import CommunityManager
from insight.community.serializers import CommunityCardSerializer


class CreateCommunity(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
        if 'tag' in request.GET and CommunityManager.tag_unique(request.GET['tag']):
            return Response({'exist': 0}, status=status.HTTP_200_OK)
        return Response({'exist': 0}, status=status.HTTP_200_OK)

    def post(self, request):
        data = json_loads(request.body)
        user: Account = request.user
        community_manager: CommunityManager = CommunityManager(user)
        community: Community = community_manager.create(**data)
        if not community:
            return Response({}, status=status.HTTP_406_NOT_ACCEPTABLE)
        return Response({}, status=status.HTTP_201_CREATED)


class GetCommunity(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
        if len(request.GET) == 0:
            # Fetch all community of the user
            communities: QuerySet = CommunityMember.objects.filter(account=user)
            serialized_data = []
            if communities:
                serialized_data = CommunityCardSerializer(communities).render()
            return Response({"communities": serialized_data}, status=status.HTTP_200_OK)
        if 'about' in request.GET:
            pass
        return Response({}, status=status.HTTP_200_OK)

