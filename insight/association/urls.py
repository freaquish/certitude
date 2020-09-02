from django.urls import path, include
from .views import *

urlpatterns = [
    path('friend/<str:target>', FriendshipManager.as_view()),
    path('friend/accept/<str:noti>', AcceptFriendRequest.as_view()),
    path('follow/<str:target>', FollowManager.as_view())
]