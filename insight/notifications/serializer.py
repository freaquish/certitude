from insight.models import Notification, get_ist
from datetime import datetime, timedelta


class NotificationSerializer:
    def __init__(self, data: Notification):
        self.data: Notification = data
        self.now = datetime.now()

    def time_offset_calculator(self, time: datetime):
        print(time, self.now, time.tzinfo, self.now.tzinfo)
        offset: timedelta = self.now - time
        if offset.days > 0:
            return f"{offset.days} d"
        else:
            seconds = offset.seconds
            minutes = seconds/60
            hours = minutes/60
            if hours > 0:
                return f"{hours} h"
            elif minutes > 0:
                return f"{minutes} min"
            return "0 min"

    def serialize(self, data):
        return {
            "avatar": data["avatar"],
            "username": data["username"],
            "account_id": data["account_id"],
            "body": data["body"],
            "intent": data["intent"],
            "intent_param": data["intent_param"],
            "time_offset": self.time_offset_calculator(data['time_stamp'])
        }

    def render(self):
        notifications = self.data
        return [self.serialize(data) for data in notifications]

