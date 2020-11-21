from rest_framework.test import APITestCase
from insight.home.main import PostActions
from insight.workers.post_creation_manager import PostCreationManager, Analyzer
from insight.models import *
from insight.tools.test_utils import cases_path
import json


class PostActionsUnitTestCase(APITestCase):

    def setUp(self) -> None:
        user_json = json.load(open(cases_path('users.json')))
        hobbies_json = json.load(open(cases_path('hobbies.json')))
        posts_json = json.load(open(cases_path('post_creation.json')))
        self.actions = json.load(open(cases_path('post_actions.json')))
        self.post_creator = Account(**user_json[0])
        self.account = Account(**user_json[1])
        self.post_creator.save()
        self.account.save()
        self.hobbies = Hobby.objects.bulk_create([Hobby(**hobby) for hobby in hobbies_json])
        self.posts = []
        for post in posts_json:
            post_manager = PostCreationManager(self.post_creator, **post)
            post_manager.create_post()
            self.posts.append(post_manager.post)

            # Celery wont work bcz of different db used
            analyzer = Analyzer(self.post_creator)
            analyzer.user_activity(analyzer.manage_scoreboard(post_manager.post, created=True))
            print("Fact Check ", post_manager.post.action_count)

    """
    Testing all home view, love, share and comments 
    from the new api
    """
    def testPostAction(self):
        pass













