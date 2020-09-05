from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from insight.models import *
from rest_framework.authentication import TokenAuthentication
from .search import SearchEngine
from .serializer import SearchSerializer


class SearchView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    """
     User sent query can search name, username, competition, community, hastag, atags, hobby
     atags will search posts and usernames, competition, community
     hastags will search posts
    """
    def get(self, request):
        user: Account = request.user
        query: str = request.GET['query']
        search_engine: SearchEngine = SearchEngine(user, query)
        if '#' in query:
            tags: QuerySet = search_engine.search_tags()
            serializer: SearchSerializer = SearchSerializer(tags).render_tag()
            return Response({"tags": serializer}, status=status.HTTP_200_OK)





