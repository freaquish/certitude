from django.urls import path, include
from insight.notifications.views import *

urlpatterns = [
    path('', NotificationView.as_view())
]
