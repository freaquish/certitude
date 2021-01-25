from rest_framework.test import APITestCase


class NotificationTest(APITestCase):

    def setUp(self) -> None:
        pass

    """
    Creates notification by passing data to Notification.log_notification
    log_notification calls create or update according to need
    
    """

    def test_notification_create(self):
        pass