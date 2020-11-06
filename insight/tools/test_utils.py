import json


def cases_path(path: str):
    return f'insight/tests/test_cases/{path}'


def cases_json(path: str):
    return json.load(open(f'insight/tests/test_cases/{path}'))
