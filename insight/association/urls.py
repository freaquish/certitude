from django.urls import path, include
from .views import *

urlpatterns = [
    path('friend/<str:target>', FriendshipMangaer.as_view())
]
