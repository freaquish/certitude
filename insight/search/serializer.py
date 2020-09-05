from insight.models import *


class SearchSerializer:
    def __init__(self, results):
        self.results = results

    @staticmethod
    def _serialize_tag(tag: Tags):
        avatar = ''
        for char in tag.tag:
            if char.isupper():
                avatar += char
            if len(avatar) > 2:
                break
        return {
            "tag": tag.tag,
            "avatar": avatar
        }

    def render_tag(self):
        rendered = []
        for tag in self.results:
            rendered.append(self._serialize_tag(tag))
        return rendered
