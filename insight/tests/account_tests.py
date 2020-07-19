from rest_framework.test import APITestCase
from rest_framework import status
import json


class RegistrationTest(APITestCase):

    def test_username_available(self):
        username = "piyush@103"
        response = self.client.get(f'/api/v1/auth/username_check?username={username}')
        self.assertEqual(response.status_code, status.HTTP_200_OK, "Status code test in username")
        dumped = response.data
        self.assertEqual(dumped['available'], 1, "username not available")

    def test_registartion(self):
        data = {"account_id": "+916392886167", "password": "piyush@103", "first_name": "Piyush",
                "last_name": "Jaiswal", "username": "piyush_103"
                }
        response = self.client.post('/api/v1/auth/register', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)