from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from django.db.models import Q
from insight.models import Notification
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from .serializer import NotificationSerializer
import json


class UsersNotification(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        notifications = Notification.objects.filter(Q(to=user) & Q(read=False))
        serialized = NotificationSerializer(notifications).render()
        return Response({"notifications": serialized}, status=status.HTTP_200_OK)
