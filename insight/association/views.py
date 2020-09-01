from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from django.db.models import Q
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


class FriendshipMangaer(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, target: str):
        user, valid = identify_token(request)
        # Create association_engine = AssociationEngine(user)
        # target --> account_id ---> target_account = Account.objects.get(account_id=target)
        # friend_association_manager(target)
        # return Response({}, status=status.HTTP_200_OK)
        association_engine = AssociationEngine(user)
        target_account = Account.objects.get(account_id = target)
        friend_association_manager(target)
        return Response({}, status=status.HTTP_200_OK)

# Class FollowManager --> follow_manager(target)
class FollowManager(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, target: str):
        user, valid = identify_token(request)
        association_engine = AssociationEngine(user)
        target_account = Account.objects.get(account_id=target)
        follow_association_manager(target)
        return Response({}, status=status.HTTP_200_OK)
