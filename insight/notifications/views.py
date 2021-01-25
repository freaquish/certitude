from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from insight.models import *
from insight.notifications.notifications import NotificationManager
from insight.notifications.serializer import NotificationSerializer


class NotificationView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    serializer_class = NotificationSerializer

    def get(self, request):
        user: Account = request.user
        notifications: list = NotificationManager.fetch_new_notification(user.account_id)
        serialized = []
        if len(notifications) > 0:
            serialized = self.serializer_class(notifications).render()
        return Response({"notifications": serialized}, status=status.HTTP_200_OK)


