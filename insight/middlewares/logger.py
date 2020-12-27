""""
Log Data of request in Data Logger
"""
from insight.workers.analyzer import Analyzer
import json


class DataLoggingMiddleware:

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Code executed before views
        Analyzer.log_data.delay(request.path, {key: str(value) for key, value in request.META.items() if "." not in key},
                                request.body if request.method == "POST" else json.dumps(request.GET.dict()))
        response = self.get_response(request)
        # Code executed after views
        return response
