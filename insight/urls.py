from django.urls import path
from .views import *

urlpatterns = [
    path('suyash/', Suyash.as_view()),
]