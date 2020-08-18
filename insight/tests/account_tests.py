from rest_framework.test import APITestCase
from rest_framework import status
import json


class RegistrationTest(APITestCase):

    def test_registration(self):
        data = {"account_id":"7081878499", 'password': 'piyush@103'}
        response = self.client.post(f'/api/v1/auth/logine', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED, "Status code test in username")
        dumped = response.data
        print(dumped)
