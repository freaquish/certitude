from insight.models import Account
from rest_framework import status
from rest_framework.test import APITestCase, force_authenticate


# class SearchTest(APITestCase):
#
#     def test_search_post(self):
#         text = 'name'
#         response = self.client.get(f'/api/v1/search?q={text}')
#         print(response.data)
#         self.assertEqual(response.status_code, status.HTTP_200_OK)


class ExploreTest(APITestCase):

    def test_explore(self):
        response = self.client.get('/api/v1/one_view/h__homies')
        print(response.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
