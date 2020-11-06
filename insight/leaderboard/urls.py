from django.urls import path
from insight.leaderboard.views import *

urlpatterns = [
    path('score', LeaderboardView.as_view()),
]