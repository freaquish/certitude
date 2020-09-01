from rest_framework.test import APITestCase
from rest_framework import status
from insight.models import *
import json


class FirendshipTest(APITestCase):

    def init(self):
        # Creating testing user for making friend
        self.user: Account = Account.objects.create(
            account_id='test_user',
            username="test_user_name",
            first_name="Demo",
            last_name="user",
            is_active=True
        )
        self.user.set_password('testing')
        self.user.save()
        self.target: Account = Account.objects.create(
            account_id='test_target',
            username="test_target_name",
            first_name="Demo",
            last_name="target",
            is_active=True
        )
        self.target.set_password('testing')
        self.target.save()
        self.user_token = Token.objects.create(user=self.user).key
        self.target_token = Token.objects.create(user=self.target).key
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.user_token)

    def test_friendship_creation(self):
        self.init()
        user_friend_count, target_friend_count = self.user.friend_count, self.target.friend_count
        response = self.client.get(
            f'/api/v1/association/friend/{self.target.account_id}')
        print(response.data)
        self.assertEqual(response.status_code, 200)
        self.user.refresh_from_db()
        self.target.refresh_from_db()
        self.assertEqual(self.target.account_id in self.user.friend, True)
        self.assertEqual(self.user.friend_count, user_friend_count + 1)
        self.assertEqual(self.target.friend_count, target_friend_count + 1)

    def test_unfriend(self):
        user_friend_count, target_friend_count = self.user.friend_count, self.target.friend_count
        response = self.client.get(
            f'/api/v1/association/friend/{self.target.account_id}')
        self.assertEqual(response.status_code, 200)
        self.user.refresh_from_db()
        self.user.refresh_from_db()
        self.target.refresh_from_db()
        self.assertEqual(self.target.account_id in self.user.friend, False)
        self.assertEqual(self.user.friend_count, user_friend_count - 1)
        self.assertEqual(self.target.friend_count, target_friend_count - 1)
