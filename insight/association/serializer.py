class FriendListSerializer:
    def __init__(self, friends, user=None):
        self.friends = friends
        self.user = user

    def _serialize(self, friend):
        data = {}
        data['account_id'] = friend.account_id
        data['username'] = friend.username
        data['avatar'] = friend.avatar
        data['first_name'] = friend.first_name
        data['last_name'] = friend.last_name
        data['is_friend'] = 1 if self.user and friend.accound_id in self.user.friend else 0
        return data

    def render(self):
        rendered = []
        for friend in self.friends:
            rendered.append(self._serialize(friend))
        return rendered


class FollowSerializer:
    def __init__(self, follows):
        self.follows = follows

    @staticmethod
    def _serialize(follow):
        data = {}
        data["account_id"] = follow.account_id
        data["username"] = follow.username
        data["avatar"] = follow.avatar
        data["first_name"] = follow.first_name
        data["last_name"] = follow.last_name

        return data

    def render(self):
        rendered = []
        for follow in self.follows:
            rendered.append(self._serialize(follow))
        return rendered
