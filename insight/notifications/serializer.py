from insight.models import Notification
from insight.utils import get_ist


class NotificationSerializer:
    def __init__(self, notifications):
        self.notifications = notifications

    @staticmethod
    def get_time_string(time):
        diff = get_ist() - time
        if diff.days > 0:
            return f"{diff.days}d"
        elif diff.seconds > 0:
            return f"{diff.seconds / 3600}h"
        else:
            return "now"

    def _serialise(self, notification: Notification):
        return {
            "type": notification.type,
            "timedelta": self.get_time_string(notification.created_at),
            "meta": notification.meta,
            "header": notification.header,
            "body": notification.body
        }

    def render(self):
        rendered = []
        for notification in self.notifications:
            rendered.append(self._serialise(notification))
        return rendered
