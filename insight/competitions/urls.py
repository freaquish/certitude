from django.urls import path
from insight.competitions.views import *

urlpatterns = [
    path('views/<str:tag>', CompetitionView.as_view(), name="competition-view"),
    path('checks', CompetitionChecks.as_view()),
    path('create', CreateCompetition.as_view()),
    path('search', CompetitionSearch.as_view())
]