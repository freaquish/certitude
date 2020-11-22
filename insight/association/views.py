from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from django.db.models import Q
from insight.models import *
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication

from insight.association.association import AssociationEngine, ManageFriends, ManageFollows
import json


class FollowManager(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    # This view single handedly operates follow/un_follow operation
    def get(self, request, target: str):
        user = request.user
        target_account = Account.objects.get(account_id=target)
        association_engine = AssociationEngine(user)
        association_engine.follow_association_manager(target_account)
        return Response({}, status=status.HTTP_200_OK)


class FollowView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, requirement: str):
        user = request.user
        if not user:
            return Response({}, status=status.HTTP_403_FORBIDDEN)
        f_manage = ManageFollows(user)
        followers = []
        following = []
        if requirement == "followers":
            followers = f_manage.fetch_followers()
        elif requirement == "followings":
            following = f_manage.fetch_followings()
        return Response({"followings": following, "followers": followers}, status=status.HTTP_200_OK)


class ThirdPersonFollowView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [AllowAny]

    def get(self, request, requirement: str):
        users = Account.objects.filter(username=request.GET['username'])
        if not users:
            return Response({}, status=status.HTTP_403_FORBIDDEN)
        user = users.first()
        f_manage = ManageFollows(user)
        followers = []
        following = []
        if requirement == "followers":
            followers = f_manage.fetch_followers()
        elif requirement == "followings":
            following = f_manage.fetch_followings()
        return Response({"followings": following, "followers": followers}, status=status.HTTP_200_OK)
