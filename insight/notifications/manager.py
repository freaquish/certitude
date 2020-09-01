from insight.models import Notification, Account
from insight.utils import get_ist
from secrets import token_urlsafe
from django.db.models import Q, QuerySet


class NotificationManager:

    def create_friend_request(self, to: Account, from_: Account):
        # Create Friend Request notification related with to(Account)
        # header = from_.username, body = from_.full_name
        # meta : avatar : from_.avatar
        notification = Notification.objects.create(
            noti_id=f'{token_urlsafe(20)}__{from_.account_id[6:]}',
            type="REQU",
            meta={"avatar": from_.avatar, "account_id": from_.account_id},
            header=from_.username,
            body=f'{from_.first_name} {from_.last_name}',
            to=to,
            created_at=get_ist(),
            read=False
        )
        to.new_notification = True
        to.save()

    def create_alert(self, to: Account, header: str, meta: dict, body: str):
        notification = Notification.objects.create(
            noti_id=f'{token_urlsafe(20)}_g{to.account_id[6:]}',
            type='ALERT',
            meta=meta,
            header=header,
            body=body,
            created_at=get_ist(),
            to=to,
            read=False
        )
        to.new_notification = True
        to.save()

    def notification_seen(self, noti_id: str):
        notifications = Notification.objects.filter(noti_id=noti_id)
        if notifications:
            notification = notifications.first()
            notification.read = True
            notification.save()

    def bulk_seen(self, account: Account):
        notifications: QuerySet = Notification.objects.filter(
            Q(to=account) & Q(read=False))
        if notifications:
            notifications.update(read=True)
