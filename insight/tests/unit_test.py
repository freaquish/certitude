from insight.models import Account
import unittest


class AccountUnitTests(unittest.TestCase):

    def test_username_availabilty_function(self):
        username: str = 'piyush'
        result = False
        if len(username) >= 6:
            accounts = Account.objects.filter(username=username)
            if not accounts:
                result = True
            else:
                result = False
        else:
            result = False
        self.assertEqual(result, False)


if __name__ == '__main__':
    unittest.main()
