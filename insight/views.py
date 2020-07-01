from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

import json


# Create your views here..

class Suyash(APIView):

    def get(self, request):
        data: dict = request.GET
        art = {
            "name": data['name'],
            "surname": "madhesia"
        }
        return Response(art, status=status.HTTP_200_OK)
