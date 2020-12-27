from rest_framework.test import APITestCase
from insight.tools.test_utils import cases_json
from insight.competitions.main import CompetitionManager
from insight.models import *
from typing import *


class CompetitionsTest(APITestCase):
    users_fixture: List[str] = cases_json('users/create.json')
    competitions_fixture: List[str] = cases_json('competitions/create.json')

    def setUp(self) -> None:
        """
        Structure of each account {"args":{required arguments},"passing": 1/0}
        """
        accounts: List[Account] = [Account(**account["args"]) for account in self.users_fixture if account["passing"] == 1]
        Account.objects.bulk_create(accounts)

    def test_competition_creation(self):
        """
        This program will test Competition creation and all plausible errors
        Main User will be created in the setUp, using bulk create
        The aspect tested here will be
        1. Sufficiency of arguments
        2. Tag uniqueness, etc

        Structure {"args", {}, "passing": 1/0}
        """
        for competition in self.competitions_fixture:
            args = competition["args"]
            try:
                account: Account = Account.objects.get(account_id=args["user_host_id"])

                # Checking tag is unique
                tags: QuerySet = Tags.objects.filter(tag=args['tag'])
                if not tags.exists() and competition["passing"] == 0:
                    raise InterruptedError('Redirecting towards except, because Tag is not unique.')
                self.assertEqual(tags.exists(), False, "Tag already exist")
                manager = CompetitionManager(account)
                competition: Competition = manager.create(**args)
                self.assertNotEqual(competition, None, "Competition creation function is returning None.")

                # checking creation of tags
                tags: QuerySet = Tags.objects.filter(tags=args['tag'])
                self.assertEqual(tags.exists(), True, f'Tag {args["tag"]} was not created.')

            except Exception as e:
                self.assertEqual(competition["passing"], 0, f'{competition["args"]["key"]} was set to {"fail" if competition["passing"] == 0 else "pass"} due to {e}.')
