from rest_framework.test import APITestCase
from rest_framework import status
import json


class RegistrationTest(APITestCase):

    def test_registration(self):
        data = {'account_id': 'test6392886167', 'username': 'jarden@103', 'first_name': 'Piyush', 'last_name':'Jaiswal',
                'details':{'email': 'iampiyushjaiswal103@gmail.com', 'phone_number': '6392886167'}, 'password': 'piyush@103'}
        response = self.client.post(f'/api/v1/auth/register', data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED, "Status code test in username")
        dumped = response.data
        print(dumped)

    