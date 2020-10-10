from rest_framework.test import APITestCase
from rest_framework import status
from insight.community.main import CommunityManager
from insight.models import *
import json


TEST_DATA ={
    "tags": [
        "piyush",
        "prague",
        "pretend2020",
        "pretend_$fi",
        "rakesh",
        "roshan",
        "test_user_name"
    ],
    'communities' : [
        {
            "name": "Rangmanch",
            "tag": "piyush",
            "hobbies": [],
            "image":""
        }
    ]
}


class CommunityManagerTest(APITestCase):

    def setUp(self) -> None:
        self.user: Account = Account.objects.create(
            account_id='test_user',
            username="rakesh",
            first_name="Demo",
            last_name="user",
            is_active=True
        )
        self.user.set_password('testing')
        self.user.save()

    def test_tag_unique(self) -> None:
        if self.user:
            manager = CommunityManager(self.user)
            for value in TEST_DATA['tags']:
                val = manager.tag_unique(value)
                if not value.isalnum():
                    self.assertEqual(val, False)
                else:
                    self.assertEqual(val, True, f'{value} {val}')

    def test_create(self) -> None:
        pass


