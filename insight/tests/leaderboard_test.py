from rest_framework.test import APITestCase
from insight.leaderboard.main import *
from insight.workers.post_creation_manager import PostCreationManager, Analyzer
from insight.actions.main import PostActions
from insight.tools.test_utils import cases_json


class LeaderboardUnitTestCase(APITestCase):
    def setUp(self) -> None:
        users_json = cases_json('users.json')
        posts_json = cases_json('post_creation.json')
        hobbies_json = cases_json('hobbies.json')
        post_actions_json = cases_json('post_actions.json')

        self.post_creator = Account(**users_json[0])
        self.user = Account(**users_json[1])
        self.post_creator.save()
        self.user.save()

        self.hobbies = Hobby.objects.bulk_create(
            [Hobby(**hobby) for hobby in hobbies_json]
        )

        self.posts = []
        for post in posts_json:
            manager = PostCreationManager(self.post_creator, **post)
            manager.create_post()
            self.posts.append(manager.post)
            analyzer = Analyzer(self.post_creator)
            analyzer.user_activity(analyzer.manage_scoreboard(manager.post, created=True))

        for action in post_actions_json:
            act = PostActions(self.post_creator if action['account_id'] == '6392886167' else self.user,
                              self.posts[0])
            act.micro_action(action['action'], for_test=True)

    def testLeaderboard(self):
        leaderboard = LeaderboardEngine(user=self.user)
        scoreboards = leaderboard.hobby_rank_global()
        print(scoreboards)
        serialized = [leaderboard.serialize_hobby_rank(scoreboard, index) for index, scoreboard in enumerate(scoreboards)]
        print(serialized)

