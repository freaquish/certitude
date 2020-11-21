from insight.leaderboard.main import LeaderboardEngine, Q, timedelta
from insight.models import *


def attest_score():
    hobbies = Hobby.objects.all()
    leaderboard = LeaderboardEngine()
    for hobby in hobbies:
        for post in leaderboard.post_rank(hobby.code_name):
            scoreboard, created = Scoreboard.objects.get_or_create(account=post.account)
            if post.hobby.code_name in scoreboard.hobby_scores:
                scoreboard.hobby_scores[post.hobby.code_name] += float(post.score)
            else:
                scoreboard.hobby_scores[post.hobby.code_name] = float(post.score)
            scoreboard.net_score = sum([float(score) for hobby, score in scoreboard.hobby_scores.items()])
            print(scoreboard.__dict__)
            scoreboard.save(update_fields=['hobby_scores', 'net_score'])
