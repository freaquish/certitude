from rest_framework.test import APITestCase
from insight.workers.post_creation_manager import PostCreationManager, Analyzer
import json
from django.db.models import Q
from insight.models import *


class PostCreationUnitTestCase(APITestCase):

    def setUp(self) -> None:
        users_file = open('insight/tests/test_cases/users.json')
        hobby_file = open('insight/tests/test_cases/hobbies.json')
        users = json.load(users_file)
        hobbies = json.load(hobby_file)
        hobbies_list = []
        for hobby in hobbies:
            hobbies_list.append(Hobby(**hobby))
        hobbies = Hobby.objects.bulk_create(hobbies_list)
        self.account = Account(**users[0])
        self.account.save()

    def testPostCreation(self):
        post_file = open('insight/tests/test_cases/post_creation.json')
        Tags.objects.create(tag='#me')
        post_json = json.load(post_file)
        created_h_tags = []
        created_a_tags = []
        created_posts = []
        # print(post_json)
        for value in post_json:
            created_h_tags.extend(value['hastags'])
            created_a_tags.extend(value['atags'])
            post_manager = PostCreationManager(self.account, **value)
            post_manager.create_post()
            created_posts.append(post_manager.post)

            # Celery wont work bcz of different db used
            analyzer = Analyzer(self.account)
            analyzer.user_activity(analyzer.manage_scoreboard(post_manager.post, created=True))

        # testing all tags are created
        all_tags = created_h_tags + created_a_tags
        tags_in_db = Tags.objects.filter(tag__in=all_tags)
        print(tags_in_db)
        print("Testing Tags -----------------------------------------------\n")
        self.assertEqual(len(all_tags), len(tags_in_db), "All tags not created")

        # testing ScorePost and Scoreboard for each post and their users
        post_query = None
        acc_query = None
        for post in created_posts:
            if post_query:
                post_query = post_query | Q(post=post)
            else:
                post_query = Q(post=post)
            if acc_query:
                acc_query = acc_query | Q(account=post.account)
            else:
                acc_query = Q(account=post.account)

        score_posts = ScorePost.objects.filter(post_query)
        scoreboards = Scoreboard.objects.filter(acc_query).values_list('account', flat=True)
        print("printing data", score_posts, scoreboards)
        self.assertEqual(created_posts, [sc_post.post for sc_post in score_posts], "All posts are not created")
        self.assertEqual([post.account.account_id for post in created_posts], list(scoreboards),
                         "All scoreboards not created")












