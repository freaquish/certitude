from rest_framework.response import Response
from rest_framework.pagination import CursorPagination

DEFAULT_PAGE = 1
DEFAULT_PAGE_SIZE = 5


class FeedPaginator(CursorPagination):
    page= DEFAULT_PAGE
    page_size = DEFAULT_PAGE_SIZE
    page_size_query_param = 'page_size'
    ordering = '-current_score' # '-creation' is default

    def get_paginated_response(self, data):
        next_link = self.get_next_link()
        if next_link is not None:
            next_link = next_link[next_link.index('?'):len(next_link)]
        return Response({
            'links': {
                'next': next_link,
                'previous': self.get_previous_link()
            },
            # 'page':int(self.request.GET.get('page', page)),
            # 'page_size': int(self.request.GET.get('page_size', self.page_size)),
            'posts': data,
            'batch': len(data)
        })
        

