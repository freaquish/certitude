from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from insight.models import *
from rest_framework.authentication import TokenAuthentication
from .search import SearchEngine
from insight.serializers import ShallowPostSerializer 
from urllib.parse import unquote


class SearchView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
        query = request.GET['q']
        query = (query.replace('h__', '#')).replace('a__', '@')
        print(user.username,'request')
        engine: SearchEngine = SearchEngine(user=user, query=query)
        results = engine.search()
        return Response(results, status=status.HTTP_200_OK)

class SearchFollowUp(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
        data = request.GET
        name = ''
        posts = []
        if 'hastag' in data:
            print(data['hastag'])
            name = f'#{data["hastag"]}'
            posts = Post.objects.filter(hastags__contains=[name])
        elif 'hobby' in data:
            name = data['hobby']
            hobbies = Hobby.objects.filter(code_name=name)
            posts = Post.objects.filter(hobby__code_name=name)
            if hobbies:
                name = hobbies.first().name
        serialized_data = ShallowPostSerializer(posts).data()
        count = len(serialized_data)
        return Response({"posts":serialized_data,"name":name,"count": count }, status=status.HTTP_200_OK)



