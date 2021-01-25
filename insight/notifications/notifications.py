from insight.models import Notification, get_ist, Account
from django.db.models import QuerySet


class NotificationManager:

    def __init__(self, from_: Account):
        self.from_: Account = from_

    @staticmethod
    def update_notification(to: str, notifications: list):
        notification_collection: QuerySet = Notification.objects.filter(account_id=to)
        if notification_collection.exists():
            user_notification: Notification = notification_collection.first()
        else:
            user_notification = Notification()
            user_notification.account_id = to
            user_notification.notifications = []
            user_notification.anyNew = False
        for notification in notifications:
            user_notification.notifications.append(notification)
        user_notification.anyNew = True
        user_notification.save()

    @staticmethod
    def create_single_notification(from_: str, username: str, body: str, avatar: str ='', intent: str = '', intent_param: str = ''):
        return {
            "account_id": from_,
            "username": username,
            "body": body,
            "avatar": avatar,
            "time_stamp": get_ist(),
            "intent": intent,
            "intent_param": intent_param
        }

    def insert_notification(self, to: Account, *notifications_array):
        notifications = [self.create_single_notification(
            self.from_.account_id, self.from_.username, data['body'],
            intent=data['intent'], intent_param=data['intent_param'],
            avatar=self.from_.avatar
        ) for data in notifications_array]

        self.update_notification(to.account_id, notifications)

    @staticmethod
    def any_new_notification(to: str):
        new_notifications: QuerySet = Notification.objects.filter(account_id=to, anyNew=True)
        return new_notifications.exists(), new_notifications

    @staticmethod
    def fetch_new_notification(to: str):
        exist, notifications = NotificationManager.any_new_notification(to)
        if not exist:
            return []
        notification: Notification = notifications.first()
        return notification.notifications

    @staticmethod
    def see_notification(to: str):
        unseen_notifications: QuerySet = Notification.objects.filter(account_id=to, anyNew=True)
        if not unseen_notifications.exists():
            return False
        unseen_notification: Notification = unseen_notifications.first()
        # save newest 50 delete else
        sorted_unseen_notification = sorted(unseen_notification.notifications,
                                            key=lambda notification: notification['time_stamp'],
                                            reverse=True
                                            )
        if len(sorted_unseen_notification) > 50:
            sorted_unseen_notification = sorted_unseen_notification[:50]
            unseen_notification.notifications = []
        unseen_notification.notifications = sorted_unseen_notification
        unseen_notification.anyNew = False
        unseen_notification.save()








