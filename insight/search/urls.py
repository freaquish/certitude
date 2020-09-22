from django.urls import path, include
from .views import *

urlpatterns = [
    path('', SearchView.as_view()),
    path('meta', SearchFollowUp.as_view())
]
