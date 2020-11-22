from insight.models import *
from django.db.models import OuterRef, QuerySet, Q, Exists


class RelevantHobby:
    def __init__(self, user: Account):
        self.user = user

    def arrange_relevant_hobbies(self, only_exist: bool = False):
        reports: QuerySet = HobbyReport.objects.filter(Q(account=self.user) & Q(hobby__code_name=OuterRef('code_name')))
        if only_exist:
            return Hobby.objects.annotate(exist=Exists(reports)).filter(exist=True)
        else:
            return Hobby.objects.annotate(exist=Exists(reports)).order_by('-exist')


