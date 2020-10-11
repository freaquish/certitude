from insight.models import Post, Account


class PostCreationManager:
    def __init__(self, user: Account):
        self.user: Account = user

