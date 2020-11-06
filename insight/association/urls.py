from django.urls import path, include
from .views import *

urlpatterns = [
    path('follow/<str:target>', FollowManager.as_view()),
    path('profile/follows/<str:requirement>', FollowView.as_view()),
    path('profile/third/follows/<str:requirement>',
         ThirdPersonFollowView.as_view()),
]
