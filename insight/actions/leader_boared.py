from celery import shared_task
from insight.models import *


class LeaderBoardManagment:

    def rank_hobby(self, hobby_name: str):
        ...