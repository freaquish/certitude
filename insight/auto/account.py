import requests as req
import json


def register_test():
    data = {'account_id': 'test6392886167', 'username': 'jarden@103', 'first_name': 'Piyush', 'last_name': 'Jaiswal',
            'details': {'email': 'iampiyushjaiswal103@gmail.com', 'phone_number': '6392886167'},
            'password': 'piyush@103'}
    response = req.post('http://localhost:8080/api/v1/auth/register', data=json.dumps(data))
    print(response)
    if response.status_code != 201:
        raise IOError()


register_test()
