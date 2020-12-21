from insight.models import Competition, Account, Hobby, Tags, HASH, Post
from insight.models import RankReport
from datetime import datetime
from django.db.models import QuerySet, Q
from secrets import token_urlsafe
from typing import List, Dict
import json

"""
Programmed by Piyush Jaiswal
on Dec 20 2020

Flow :
  - Sent competition tags will be verified whether the post is submittable to any competition
     - If found no competition then kill the process of post creation
  - Attach Post to Competition and create RankReport of user with each competition


Tabs :
   - About 
       - Images
       - Details
       - Credits
  - Feed
       - Submitted post
  - Leaderboard
  

Structure of Competition View
Tabs := Tab names alon with complete urls
     : name := Name of Tab (key)
     : url := Url (value)
Default Tab := Selected tab sent, different for users
     :: if user has participated | user is host -> Feed
     :: else -> About
Is Ended := Bool declaration whether the competition is ended
Is Finished := Bool declaration whether the competition has finished with results
Start := Start date time in format
End := End date time in format
Result := Result date time in format
Is Participated := Bool whether user requesting the page has participated
Is Host := Bool whether the user is host
Body := Body of view

Dynamic = Default Tab ,Body, Is Participated, Is Host

@Error
1. Race condition when same post in multiple competition, counting of post score
2. Slotting, holding post until competitions begin.

"""


class CompetitionResponse(object):
    def __init__(self, **kwargs):
        self.data: Dict = kwargs

    def attach(self, key: str, value):
        self.data[key] = value

    def dump(self):
        return json.dumps(self.data)

    def __getitem__(self, item: str):
        return self.data[item]

    def __setitem__(self, key: str, value):
        self.attach(key, value)


class RankReportManager:
    def __init__(self, user: Account):
        self.user: Account = user

    @staticmethod
    def create(competition: Competition, post: Post):
        report: RankReport = RankReport.objects.create(
            user_id=post.account.account_id, competition_key=competition.key,
            expiry=competition.result, alive_from=competition.start
        )


class CompetitionManager:

    def __init__(self, account: Account):
        self.user: Account = account
        self.hobbies: QuerySet = None
        self.dt_format: str = "%d-%m-%Y %H:%M:%S %z"

    @staticmethod
    def generate_tab_url(tab: str, competition_tag: str):
        """
        Generates tab url using reverse for accessing competition and tab
        TODO: Need to write this after we write tab switch view
        """
        pass

    def view(self, tag: str):
        competitions: QuerySet = Competition.objects.prefetch_related('posts')\
            .select_related('user_post').filter(tag=tag)
        if not competitions.exists():
            raise Exception("Competition does not exist.")
        competition: Competition = competitions.first()
        today: datetime = datetime.now().astimezone(competition.end.tzinfo)
        data: CompetitionResponse = CompetitionResponse(**{
            "tabs": {
                "About": self.generate_tab_url("about", competition.tag),
                "Feed": self.generate_tab_url("feed", competition.tag),
                "Leaderboard": self.generate_tab_url("leaderboard", competition.tag)
            },
            "start": competition.start.strftime(self.dt_format),
            "end": competition.end.strftime(self.dt_format),
            "result": competition.result.strftime(self.dt_format),
            "is_ended": True if today > competition.end else False,
            "is_finished": True if today > competition.result else False,
        })
        if isinstance(self.user, Account):
            return self.know_user_view(competition)
        return self.anonymous_user_view(competition)

    def competition_feed(self, competition: Competition):
        """
        TODO: Need to look into this
        """
        pass

    @staticmethod
    def competition_about(competition: Competition):
        data = {"details": competition.details, 'host': {
            "avatar": competition.user_host.avatar,
            "username": competition.user_host.username,
            "name": competition.user_host.first_name + " " + competition.user_host.last_name,
        }, "images": competition.images}
        return data

    def competition_leaderboard(self, competition: Competition):
        pass

    @staticmethod
    def key_generator():
        return token_urlsafe(22)

    def sanitize(self, **kwargs) -> dict:
        """
        Sanitize data and assures all must-required parameters are present.
        @required tag, start, end, images, hobbies, name, details, is_public_competition
        Date Time Format DD-MM-YYYY HH:mm:ss TZ
        """
        assert ('tag' in kwargs and "name" in kwargs and "images" in kwargs and
                "hobbies" in kwargs and "details" in kwargs and "start" in kwargs and "end" in kwargs
                and "result" in kwargs and "judged_by_user" in kwargs
                ), "Missing required parameters."
        data = kwargs.copy()
        if "is_public_competition" in kwargs and kwargs["is_public_competition"] == 0:
            data["is_public_competition"] = False
        else:
            data["is_public_competition"] = True

        data['start'] = datetime.strptime(kwargs['start'], self.dt_format)
        data['end'] = datetime.strptime(kwargs['end'], self.dt_format)
        data['result'] = datetime.strptime(kwargs['result'], self.dt_format)
        if not data['start'] < data['end'] and data['end'] < data['result']:
            raise AttributeError('Time constraints are not valid.')
        self.hobbies: QuerySet = Hobby.objects.filter(code_name__in=data['hobbies'])
        if not self.hobbies.exists():
            raise ValueError("At least 1 hobby is required.")
        del data['hobbies']
        data['judged_by_user'] = True if kwargs['judged_by_user'] == 1 else False
        data['user_host'] = self.user
        data['key'] = self.key_generator()
        return data

    def create(self, **kwargs) -> Competition:
        data: dict = self.sanitize(**kwargs)
        tags: QuerySet = Tags.objects.filter(tag=data['tag'])
        if tags.exists():
            raise Exception("Tag already exist")
        tag: Tags = Tags.objects.create(
            tags=data['tag'], tag_type=HASH
        )
        competition: Competition = Competition(**data)
        competition.hobbies.set(self.hobbies)
        return competition

    def ban_users(self, competitions: List[str], users: List[str]) -> QuerySet:
        """
        Ban users will allow bulk ban of multiple users in multiple competitions
        First it needs to check whether these competitions are owned by commanding user
        """
        competition_set: QuerySet = Competition.objects.filter(
            Q(tag__in=competitions) & Q(user_host=self.user))
        if not competition_set.exists():
            raise Exception("Competition doesn't exist.")
        for competition in competition_set.iterator():
            competition.banned_users += users
            competition.banned_users = list(set(competition.banned_users))
            competition.save()
        return competition_set

    def ban_posts(self, competitions: List[str], posts: List[str]) -> QuerySet:
        competition_set: QuerySet = Competition.objects.filter(
            Q(tag__in=competitions) & Q(user_host=self.user)
        )
        if not competition_set.exists():
            raise Exception("Competition doesn't exist.")
        for competition in competition_set.iterator():
            competition.banned_posts += posts
            competition.banned_posts = list(set(competition.banned_posts))
            competition.save()
        return competition_set

    def add_post(self, post: Post, competitions: List[str]):
        """
        Append post in competitions, if post is already submitted by user than skip competition
        Create rank report
        """
        competition_set: QuerySet = Competition.objects.prefetch_related('posts')\
            .select_related('user_host').filter(tag__in=competitions)
        if not competition_set.exists():
            raise Exception("Competition doesn't exist.")
        last_competition = competition_set.first().result
        for competition in competition_set.iterator():
            post_already_submitted: QuerySet = competition.posts.filter(
                account__account_id=post.account.account_id)
            if post_already_submitted.exists():
                continue
            competition.posts.add(post)
            if last_competition < competition.result:
                last_competition = competition.result
            if post.account_id == competition.user_host.account_id:
                competition.judged_by_user = False
                competition.save()
        post.last_validity = last_competition
        post.used_in_competition = True
        post.save()
        return competition_set

    def edit(self, tag: str, **kwargs) -> Competition:
        """
        Only updatable fields are images, hobby, end, result, start, name and details
        add, remove actions can be called
        if images are sent were 2 images are removed 1 is added then
        images_add=[str]&images_remove=[str]
        """
        competitions: QuerySet = Competition.objects.select_related('user_host')\
            .filter(tag=tag)
        if not competitions.exists():
            raise Exception("Competition doesn't exist.")
        competition: Competition = competitions.first()
        if competition.user_host != self.user:
            raise AssertionError("Not enough authority.")
        if "images_add" in kwargs:
            images: List[str] = kwargs['images_add']
            competition.images = list(set(competition.images + images))
        if "images_remove" in kwargs:
            images: List[str] = kwargs["images_remove"]
            competition.images = list(set(competition.images).difference(set(images)))
        if "hobby_add" in kwargs:
            hobby: QuerySet = Hobby.objects.filter(code_name__in=kwargs['hobby_add'])
            if hobby.exists():
                competition.hobbies.add(*hobby)
        if "hobby_remove" in kwargs:
            hobby: QuerySet = Hobby.objects.filter(code_name__in=kwargs['hobby_remove'])
            if hobby.exists():
                competition.hobbies.remove(*hobby)
        if "end" in kwargs:
            competition.end = datetime.strptime(kwargs['end'], self.dt_format)
        if "result" in kwargs:
            competition.result = datetime.strptime(kwargs['result'], self.dt_format)

            # Update expiry in RankReport
            reports: QuerySet = RankReport.objects.filter(competition_key=competition.key)
            reports.update(expiry=competition.result)
        if "start" in kwargs:
            competition.start = datetime.strptime(kwargs['start'], self.dt_format)

            # Update alive_from in every RankReport
            reports: QuerySet = RankReport.objects.filter(competition_key=competition.key)
            reports.update(alive_from=competition.start)
        if "name" in kwargs:
            competition.name = kwargs['name']
        if "details" in kwargs:
            competition.details = kwargs['details']
        competition.save()
        return competition

    def lift_ban_users(self, competitions: List[str], users: List[str]) -> QuerySet:
        competition_set: QuerySet = Competition.objects.filter(
            Q(tag__in=competitions) & Q(user_host=self.user)
        )
        if not competition_set.exists():
            return None
        for competition in competition_set.iterator():
            competition.banned_users = list(set(competition.banned_users).difference(set(users)))
            competition.save()
        return competition_set

    def lift_ban_posts(self, competitions: List[str], posts: List[str]) -> QuerySet:
        competition_set: QuerySet = Competition.objects.filter(
            Q(tag__in=competitions) & Q(user_host=self.user)
        )
        if not competition_set.exists():
            return None
        for competition in competition_set.iterator():
            competition.banned_posts = list(set(competition.banned_posts).difference(set(posts)))
            competition.save()
        return competition_set










