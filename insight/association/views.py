from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from django.db.models import Q
from insight.models import Account, Notification
from insight.models import *
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication

from insight.association.association import AssociationEngine, ManageFriends, ManageFollows
import json


def identify_token(request):
    if 'HTTP_AUTHORIZATION' in request.META:
        token_key = request.META.get('HTTP_AUTHORIZATION')
        token_key = "".join(token_key.split('Token ')
                            ) if 'Token' in token_key else token_key
        tokens = Token.objects.filter(key=token_key)
        if not tokens:
            return None, False
        token = tokens.first()
        return token.user, True


class FriendshipManager(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, target: str):
        user, valid = identify_token(request)
        association_engine = AssociationEngine(user)
        target_accounts: QuerySet = Account.objects.filter(username=target)
        if not target_accounts:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        target_account: Account = target_accounts.first()
        association_engine.friend_association_manager(target_account)
        return Response({}, status=status.HTTP_200_OK)


class AcceptFriendRequest(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, username):
        user: Account = request.user
        accounts: QuerySet = Account.objects.filter(username=username)
        if not accounts:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        account: Account = accounts.first()
        notifications: QuerySet = Notification.objects.filter(Q(to=user) & Q(Q(header=account.username) & Q(type='REQU')))
        if notifications:
            notification = notifications.first()
            notification.read = True
            notification.used = True 
            notification.save()
        association_engine = AssociationEngine(user)
        association_engine.accept_friend_request(account)
        return Response({}, status=status.HTTP_200_OK)

class ObjectFriendRequest(APIView):
    authenticatio_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, action,username):
        user: Account = request.user 
        accounts: QuerySet = Account.objects.filter(username=username)
        if not accounts:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        account: Account = accounts.first()
        if action == 'cancel':
            notifications: QuerySet = Notification.objects.filter(Q(to=account) & Q(Q(header=user.username) & Q(type='REQU')))
        elif action == 'reject':
            notifications: QuerySet = Notification.objects.filter(Q(to=user) & Q(Q(header=account.username) & Q(type='REQU')))
        if notifications:
            notification: Notification = notifications.first()
            notification.read = True
            notification.used = True
            notification.save()
        return Response({}, status=status.HTTP_200_OK)

class UnfriendView(APIView):
    authenticatio_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, target):
        user: Account = request.user 
        manager = AssociationEngine(user)
        target_accounts: QuerySet = Account.objects.filter(username=target)
        if not target_accounts:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        target_account: Account = target_accounts.first()
        manager.remove_friend(target_account)
        return Response({}, status=status.HTTP_200_OK)


class FollowManager(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    # This view single handedly operates follow/un_follow operation
    def get(self, request, target: str):
        user, valid = identify_token(request)
        target_account = Account.objects.get(account_id=target)
        association_engine = AssociationEngine(target_account)
        association_engine.follow_association_manager(user)
        return Response({}, status=status.HTTP_200_OK)


class FriendView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self,request,requirement):
        user: Account = request.user
        if requirement != 'self':
            accounts: QuerySet = Account.objects.filter(username=requirement)
            if not accounts:
                return Response({},status=status.HTTP_404_NOT_FOUND)
            account: Account = accounts.first()
            if account != user:
                manager = ManageFriends(account)
                friends = manager.fetch_friends()
                return Response({"friends":friends},status=status.HTTP_200_OK)
        manager = ManageFriends(user)
        friends = manager.fetch_friends()
        return Response({"friends":friends},status=status.HTTP_200_OK)

class FollowView(APIView):
    authenticatio_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, requirement: str):
        user, valid = identify_token(request)
        if not valid:
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
    authenticatio_classes = [TokenAuthentication]
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
