import requests
import json


class factory:
    def __init__(self, *prelims):
        self.headers = {}
        if 'token' in prelims:
            self.token = prelims['token']
            self.headers = {'Authorization' : f'Token {self.token}'}
        if 'base_url' in prelims:
            self.base_url = prelims
        else:
            self.base_url = ''

    def get(self, url, *data):
        final_url = f'{self.base_url}{url}'
        if 'header' in data:
            self.header.update(data['header'])
        if 'query' in data:
            final_url = f'{final_url}?'
            for index,key in enumerate(data['query']):
                final_url = f'{final_url}{key}={data["query"]["value"]}' if index == 0 else f'{final_url}&{key}={data["query"]["value"]}'
        response = requests.get(final_url,headers=self.headers)
        return response

    def post(self, url, *data):
        final_url = f'{self.base_url}{url}'
        if 'header' in data:
            self.header.update(data['header'])
        response = requests.post(final_url,data=data['data'] if 'data' in data else {},headers=self.headers)
        return response
