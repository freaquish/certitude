from insight.models import *


class Filter:
    def __init__(self, account_id=None):
        if account_id:
            self.account_id = account_id
            self.account = Account.objects.get(account_id=self.account_id)