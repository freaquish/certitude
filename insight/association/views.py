from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from django.db.models import Q
from insight.models import Account, Notification
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication

from insight.association.association import AssociationEngine
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
        target_account: Account = Account.objects.get(account_id=target)
        association_engine.friend_association_manager(target_account)
        return Response({}, status=status.HTTP_200_OK)


class AcceptFriendRequest(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, noti):
        target, valid = identify_token(request)
        notifications = Notification.objects.filter(noti_id=noti)
        if not notifications:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        notification = notifications.first()
        notification.read = True
        notification.save()
        user = Account.objects.get(pk=notification.meta['account_id'])
        association_engine = AssociationEngine(user)
        association_engine.accept_friend_request(target)
        return Response({}, status=status.HTTP_200_OK)


class FollowManager(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, target: str):
        user, valid = identify_token(request)
        association_engine = AssociationEngine(user)
        target_account = Account.objects.get(account_id=target)
        association_engine.follow_association_manager(target_account)
        return Response({}, status=status.HTTP_200_OK)
