from insight.models import *
from celery import shared_task
from django.db.models import Q
from insight.utils import NOTIFICATION_FRIEND_REQUEST, NOTIFICATION_FRIEND_RESPONSE


class NotificationActions:

    def __init__(self, requested_id = None, requesting_id=None):
        if requested_id:
            self.requested_id = requested_id
            self.requested_user = Account.objects.get(account_id=self.requested_id)
        if requesting_id:
            self.requesting_id = requesting_id
            self.requesting_user = Account.objects.get(account_id=self.requesting_id)

    def accept_friend_request(self):
        self.requesting_user.friend = self.requesting_user.friend + [
            self.requested_id] if self.requesting_user.friend else [self.requested_id]
        self.requesting_user.friend_count += 1
        self.requested_user.new_notification = True
        self.requesting_user.save()
        self.requested_user.friend = self.requested_user.friend + [
            self.requesting_id] if self.requested_user.friend else [self.requesting_id]
        self.requested_user.friend_count += 1
        self.requested_user.save()
        self.send_notification([self.requesting_id], f'{self.requested_user.first_name} {self.requested_user.last_name}',
                               f'{self.requested_user.username} has accepted your friend request.',
                               image=self.requested_user.avatar,notification_type=NOTIFICATION_FRIEND_RESPONSE,
                               meta={
                                   'requested_user': self.requested_id,
                                   'response': 'ACCEPTED',
                                   'flag': 'good'
                               }
                               )

    def unfriend_user(self):
        self.requesting_user.friend.remove(self.requested_id)
        self.requested_user.friend.remove(self.requesting_id)
        self.requesting_user.friend_count += 1
        self.requested_user.friend_count += 1
        self.requested_user.save()
        self.requesting_user.save()

    def follow_user(self):
        self.requesting_user.following.append(self.requested_id)
        self.requesting_user.following_count += 1
        self.requested_user.new_notification = True
        self.requested_user.follower_count +=1
        self.requested_user.save()
        self.requesting_user.save()
        self.send_notification([self.requested_id],
                               f'{self.requesting_user.first_name} {self.requesting_user.last_name}',
                               f'{self.requesting_user.username} started following you',
                               image=self.requesting_user.avatar,
                               meta={
                                   'requesting_user': self.requesting_id
                               },
                               notification_type=STARTED_FOLLOWING
                               )

    def unfollow_user(self):
        self.requesting_user.following.remove(self.requested_id)
        self.requesting_user.following_count -= 1
        self.requested_user.follower_count += 1
        self.requesting_user.save()
        self.requested_user.save()

    def decline_friend_request(self):
        self.requested_user.friend_requests.remove(self.requesting_id)
        self.requested_user.save()
        self.requesting_user.new_notification = True
        self.requesting_user.save()
        self.send_notification([self.requesting_id],
                               f'{self.requested_user.first_name} {self.requested_user.last_name}',
                               f'{self.requested_user.username} has declined your friend request.',
                               notification_type=NOTIFICATION_FRIEND_RESPONSE, image=self.requested_user.avatar,
                               meta={'requested_user': self.requested_id,
                                     'response': 'DECLINED', 'flag': 'bad'
                                     }
                               )

    def send_friend_request(self):
        self.requested_user.friend_requests = self.requested_user.friend_requests + [
            self.requesting_id] if self.requested_user.friend_requests else [self.requesting_id]
        self.requested_user.save()
        self.send_notification([self.requested_id],
                               f'{self.requesting_user.first_name} {self.requesting_user.last_name}',
                               '', notification_type=NOTIFICATION_FRIEND_REQUEST,
                               image=self.requesting_user.avatar,
                               meta={'requesting_user': self.requesting_id, 'flag': 'good'}
                               )

    @staticmethod
    def send_notification(recievers, header, body, notification_type=GENERAL_ACTIVITY, image='', meta={}):
        notification = Notification.objects.create(
            accounts=recievers,
            notification_type=notification_type,
            created=get_ist(),
            header=header,
            body=body,
            image=image,
            meta=meta
        )



@shared_task
def notify_about_new_post(post_id,post_hobby_name, account_id):
    account: Account = Account.objects.get(account_id=account_id)
    notification_action: NotificationActions = NotificationActions()
    receivers = Account.objects.filter(Q(following__contains=[account_id]) | Q(friend__contains=[account_id]))
    sanitized_recievers = list(set([user.account_id for user in receivers]))
    notification_action.send_notification(sanitized_recievers,f'New Post from{account.first_name} {account.last_name}',
                                          f'{account.username} has posted new feed in {post_hobby_name}, have a look.',
                                          notification_type=NEW_POST,
                                          image=account.avatar,
                                          meta={
                                              'post_id':post_id,
                                          }
                                          )
    return None
