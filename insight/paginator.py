from rest_framework.response import Response
from rest_framework.pagination import CursorPagination

DEFAULT_PAGE = 1
DEFAULT_PAGE_SIZE = 5


class FeedPaginator(CursorPagination):
    page = DEFAULT_PAGE
    page_size = DEFAULT_PAGE_SIZE
    page_size_query_param = 'page_size'
    ordering = ['-current_score', '-hobby_score']

    def get_paginated_response(self, data):
        next_link = self.get_next_link()
        if next_link is not None:
            next_link = next_link[next_link.index('?'):len(next_link)]
        return Response({
            'links': {
                'next': next_link,
                'previous': self.get_previous_link()
            },
            'posts': data,
        })


class DiscoverPaginator(CursorPagination):
    page = 1
    page_size = 5
    page_size_query_param = 'page_size'
    ordering = 'action_score', 'f_score'

    def get_paginated_response(self, data):
        next_link = self.get_next_link()
        if next_link is not None:
            next_link = next_link[next_link.index('?'):len(next_link)]
        return Response({
            'links': {
                'next': next_link,
                'previous': self.get_previous_link()
            },
            'posts': data,
        })


class CompetitionFeedPaginator(FeedPaginator):
    ordering = '-score', 'viewed'

    def get_paginated_response(self, data):
        next_link = self.get_next_link()
        if next_link is not None:
            next_link = next_link[next_link.index('?'):len(next_link)]
        return Response({
            'links': {
                'next': next_link,
                'previous': self.get_previous_link()
            },
            'data': data,
        })


