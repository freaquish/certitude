from django.urls import path, include
from .views import *

urlpatterns = [
    path('friend/request/<str:target>', FriendshipManager.as_view()),
    path('friend/accept/<str:username>', AcceptFriendRequest.as_view()),
    path('friend/object/<str:action>/<str:username>' ObjectFriendRequest.as_view()),
    path('friend/un/<str:target>', UnfriendView.as_view()),
    path('follow/<str:target>', FollowManager.as_view()),
    path('friends/<str:requirement>', FriendView.as_view()),
    path('profile/follows/<str:requirement>', FollowView.as_view()),
    path('profile/third/follows/<str:requirement>',
         ThirdPersonFollowView.as_view()),
]
