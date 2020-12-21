from rest_framework.test import APITestCase
from insight.tools.test_utils import cases_json
from insight.competitions.main import CompetitionManager, Account


class CompetitionCreationTest(APITestCase):

    def setUp(self) -> None:
        user_cases = cases_json('users.json')
        self.users = Account.objects.bulk_create(
            [Account(**user) for user in user_cases]
        )

    def testCreation(self):
        """
          Test whether it creates competition
          @important inputs are
           tag, start, end, result, images, hobbies, name,
           details
          1 - Check program is throwing error on less data
          2 - Program is creating competition
        """
        pass

