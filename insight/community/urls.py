from django.urls import path
from insight.community.views import *

urlpatterns = [
    path('create', CreateCommunity.as_view()),
    path('', GetCommunity.as_view()),
]