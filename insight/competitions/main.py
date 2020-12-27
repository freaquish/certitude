from django.db.models.functions import DenseRank

from insight.models import Competition, Account, Hobby, Tags, HASH, Post
from insight.models import RankReport, HobbyReport
from datetime import datetime
from django.db.models import QuerySet, Q, Window, F, Count
from secrets import token_urlsafe
from typing import List, Dict
import json
from insight.utils import get_ist
from insight.database.postgres import Levenshtein
from insight.serializers import PostSerializer
from celery import shared_task

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
  - Banned Post
  - Banned Users
  

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


@shared_task
def periodic_task():
    print('Hell')


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


def ranking(string: str) -> Window:
    return Window(
            expression=DenseRank(),
            order_by=F(string).desc()
        )


class RankReportManager:
    def __init__(self, user: Account):
        self.user: Account = user

    @staticmethod
    def create(competitions: QuerySet, post: Post):
        reports = []
        today = get_ist()
        for competition in competitions.iterator():
            report: RankReport = RankReport(user_id=post.account_id, created=today,
                                            tree=[{"score": post.score, "logged_on": today}], current_score=post.score,
                                            competition_key=competition.key,
                                            alive_from=competition.start.astimezone(today.tzinfo),
                                            expiry=competition.result.astimezone(today.tzinfo)
                                            )

            reports.append(report)
        RankReport.objects.bulk_create(reports)

    @staticmethod
    def periodic_ranking():
        from django.db.models.functions import Trunc
        from django.db.models import DateTimeField
        today = get_ist().today()
        today = CompetitionManager.get_date_time(today)
        competitions: QuerySet = Competition.objects.prefetch_related('posts').annotate(result_date=Trunc('result', kind='day',
                                                                                output_field=DateTimeField()))\
            .filter(result_date=today)
        for competition in competitions.iterator():
            rank_reports: QuerySet = RankReport.objects.filter(competition_key=competition.key)\
                .annotate(ranked=ranking('current_score'))
            if not rank_reports.exists():
                return None
            for report in rank_reports.iterator():
                report.current_rank = report.ranked
                report.tree[-1]["rank"] = report.ranked
                report.result_declared = True
            RankReport.objects.bulk_update(rank_reports, ['current_rank', 'tree', 'result_declared'])
        return None

    @staticmethod
    def update_score(post: Post):
        competitions: QuerySet = Competition.objects.filter(
            Q(posts__post_id=post.post_id) & ~Q(banned_users__contains=[post.account_id]))
        if not competitions.exists():
            return None
        reports: QuerySet = RankReport.objects.filter(
            Q(user_id=post.account_id) & Q(expiry__gte=get_ist()) &
            Q(alive_from__lte=get_ist()) &
            Q(competiton_key__in=[competition.key for competition in competitions.iterator()])
        )
        if not reports.exists():
            return None
        for report in reports.iterator():
            report.current_score = post.score
            if report.tree[-1]["score"] != post.score:
                report.tree.append({"score": post.score, "logged_on": get_ist()})
        RankReport.objects.bulk_update(reports, ['current_score', 'tree'])


class CompetitionManager:
    competition: Competition = None

    def __init__(self, account: Account):
        self.user: Account = account
        self.hobbies: QuerySet = None
        self.dt_format: str = "%d-%m-%Y %H:%M:%S"

    def submittable_competitions(self, **kwargs) -> [QuerySet, Dict]:
        """
        Requested by user creating post, called before an operation in create post
        returns competitions
        """
        if 'competition_tags' not in kwargs:
            return None
        competition_tags: List[str] = kwargs['competition_tags']
        competitions: QuerySet = Competition.objects.prefetch_related('posts').select_related('user_host').filter(
            Q(key__in=competition_tags) & ~Q(banned_user__icontains=self.user.account_id)
        )
        if not competitions.exists():
            raise AssertionError("No Competition exist.")
        alive_from = None
        last_validity = None
        today = get_ist()
        for competition in competitions.iterator():
            if alive_from is None:
                alive_from = competition.start.astimezone(today.tzinfo)
            elif alive_from and competition.start.astimezone(today.tzinfo) < alive_from:
                alive_from = competition.start.astimezone(today.tzinfo)
            if last_validity is None:
                last_validity = competition.result.astimezone(today.tzinfo)
            elif last_validity and competition.result.astimezone(today.tzinfo) > last_validity:
                last_validity = competition.result.astimezone(today.tzinfo)

        return competitions, {"alive_from": alive_from, "last_validity": last_validity}

    @staticmethod
    def generate_tab_url(tab: str, competition_tag: str):
        """
        Generates tab url using reverse for accessing competition and tab
        TODO: Need to write this after we write tab switch view
        """
        pass

    def view(self, tag: str, **kwargs):
        competitions: QuerySet = Competition.objects.prefetch_related('posts') \
            .select_related('user_post').filter(tag=tag)
        if not competitions.exists():
            raise Exception("Competition does not exist.")
        self.competition: Competition = competitions.first()
        today: datetime = datetime.now().astimezone(self.competition.end.tzinfo)
        data: CompetitionResponse = CompetitionResponse(**{
            "tabs": {
                "About": self.generate_tab_url("about", self.competition.tag),
                "Feed": self.generate_tab_url("feed", self.competition.tag),
                "Leaderboard": self.generate_tab_url("leaderboard", self.competition.tag)
            },
            "start": self.competition.start.strftime(self.dt_format),
            "end": self.competition.end.strftime(self.dt_format),
            "result": self.competition.result.strftime(self.dt_format),
            "is_ended": True if today > self.competition.end else False,
            "is_finished": True if today > self.competition.result else False,
        })
        body, tab = {}, None
        if "tab" in kwargs:
            body, tab = self.get_tab(tab=kwargs['tab'])
        else:
            body, tab = self.get_tab()
        data.attach("body", body)
        data.attach("current_tab", tab)
        return data

    def _get_tab(self, tab: str):
        if tab == "About":
            return self.competition_about(self.competition), "About"
        elif tab == "Feed":
            return self.competition_feed(self.competition), "Feed"
        elif tab == "Leaderboard":
            return self.competition_leaderboard(self.competition), "Leaderboard"

    def get_tab(self, tab: str = None):
        if tab:
            return self._get_tab(tab)
        if not isinstance(self.user, Account):
            return self._get_tab("About")
        posts: QuerySet = Post.objects.filter(Q(competitions__key=self.competition.key))
        if posts.exists():
            return self._get_tab("Feed")
        return self._get_tab("About")

    def competition_feed(self, competition: Competition) -> QuerySet:
        """
        Fetch all allowed posts i.e which are not banned
        TODO: Need to complete this on Tues
        """
        posts: QuerySet = Post.objects.prefetch_related('views').filter(
            Q(competitions__key=competition) &
            ~Q(Q(competitions__banned_posts__contains=F('post_id') |
               Q(competitions__banned_users__contains=F('account_id'))))).annotate(
            is_host=Count('competitions', filter=Q(Q(judged_by_user=True) &
                                                   Q(competitions__user_host_id=self.user.account_id))),
            viewed=Count('viewactionmodel',
                         filter=Q(viewactionmodel__account_id=self.user.account_id)))
        return posts

    @staticmethod
    def competition_about(competition: Competition) -> CompetitionResponse:
        data = {"details": competition.details, 'host': {
            "avatar": competition.user_host.avatar,
            "username": competition.user_host.username,
            "name": competition.user_host.first_name + " " + competition.user_host.last_name,
        }, "images": competition.images}
        return data

    @staticmethod
    def competition_leaderboard(competition: Competition) -> QuerySet:
        reports: RankReport = RankReport.objects.select_related('user').filter(competition_key=competition.key)\
            .annotate(ranked=ranking('current_score')).distinct().order_by('ranked')
        return reports

    @staticmethod
    def get_competition_post_user(competition_id: str, user_id: str):
        posts: QuerySet = Post.objects.filter(Q(account_id=user_id) & Q(competitions__key=competition_id))
        return posts

    @staticmethod
    def key_generator():
        return token_urlsafe(22)

    @staticmethod
    def get_date_time(date_time: datetime):
        return datetime(datetime.year, datetime.month, datetime.day, hour=12, tzinfo=date_time.tzinfo)

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

        tz_info = get_ist().tzinfo
        data['start'] = self.get_date_time(datetime.strptime(kwargs['start'], self.dt_format).astimezone(tz_info))
        data['end'] = self.get_date_time(datetime.strptime(kwargs['end'], self.dt_format).astimezone(tz_info))
        data['result'] = self.get_date_time(datetime.strptime(kwargs['result'], self.dt_format).astimezone(tz_info))
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
            Q(tag__in=competitions) & Q(user_host=self.user) & Q(judged_by_user=False))
        if not competition_set.exists():
            raise Exception("Competition doesn't exist.")
        for competition in competition_set.iterator():
            competition.banned_users += users
            competition.banned_users = list(set(competition.banned_users))
        Competition.objects.bulk_update(competitions, ['banned_users'])
        return competition_set

    def ban_posts(self, competitions: List[str], posts: List[str]) -> QuerySet:
        competition_set: QuerySet = Competition.objects.filter(
            Q(tag__in=competitions) & Q(user_host=self.user) & Q(judged_by_user=False)
        )
        if not competition_set.exists():
            raise Exception("Competition doesn't exist.")
        for competition in competition_set.iterator():
            competition.banned_posts += posts
            competition.banned_posts = list(set(competition.banned_posts))
        Competition.objects.bulk_update(competitions, ['banned_posts'])
        return competition_set

    def add_post(self, post: Post, competitions):
        """
        Append post in competitions, if post is already submitted by user than skip competition
        Create rank report
        """
        competition_set: QuerySet = competitions
        if isinstance(competitions, list):
            competition_set: QuerySet = Competition.objects.prefetch_related('posts') \
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
            RankReportManager(post.account).create(competition, post)
            if last_competition < competition.result:
                last_competition = competition.result
            if post.account_id == competition.user_host.account_id:
                competition.judged_by_user = False
        Competition.objects.bulk_update(competitions, ['posts', 'judged_by_user'])
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
        competitions: QuerySet = Competition.objects.select_related('user_host') \
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
        Competition.objects.bulk_update(competitions, ['banned_users'])
        return competition_set

    def lift_ban_posts(self, competitions: List[str], posts: List[str]) -> QuerySet:
        competition_set: QuerySet = Competition.objects.filter(
            Q(tag__in=competitions) & Q(user_host=self.user)
        )
        if not competition_set.exists():
            return None
        for competition in competition_set.iterator():
            competition.banned_posts = list(set(competition.banned_posts).difference(set(posts)))
        Competition.objects.bulk_update(competitions, ['banned_posts'])
        return competition_set


class CompetitionSearch:

    def __init__(self, user: Account, **data):
        self.user = user
        self.data = data

    def search_using_hobbies(self):
        return Competition.objects.filter(
            Q(hobbies__code_name__in=self.data['hobbies'])).order_by('-result')

    def search_using_tag(self):
        query = Q(tag__istartswith=self.data['tag'])
        if 'hobby_bound' in self.data:
            query = query & Q(hobbies__code_name__in=self.data['hobby_bound'])
        return Competition.objects.filter(query)

    @staticmethod
    def search_all_activity(is_live=True):
        today = get_ist()
        query = Q(start__lte=today) & Q(result__gte=today)
        return Competition.objects.filter(query)

    def competition_filter(self):
        """
        For complex queries as
        1. User want to sort all the competitions live|submittable| coming | passed in a hobby [is_live(bool) |
         is_submittable(bool) | is_coming(bool) | is_passed(bool), hobbies(list)   ]
        2. User want to get all hobbies he has participated   [hobbies(list) | other_user(str), participated(bool) ]
        3. User want to find Competition by tag but in a given hobby or not  [tag(str), name(str), hobbies(list)

        Sorting options
        1. Start
        2. End
        3. Span
        """
        hobbies = []
        today = get_ist()
        if 'hobbies' in self.data:
            hobbies = self.data['hobbies']

        else:
            hobby_set: QuerySet = HobbyReport.objects.select_related('hobby').filter(account_id=self.user.account_id)\
                .values_list('hobby__code_name', flat=True)
            if not hobby_set.exists():
                hobby_set: QuerySet = Hobby.object.all().values_list('code_name', flat=True)
            hobbies = hobby_set
        query = Q(hobbies__code_name__in=hobbies)
        annotate = {"post_count": Count('posts')}
        if "is_live" in self.data:
            query = query & Q(start__lte=today) & Q(result__gte=today)
        elif "is_submittable" in self.data:
            query = query & Q(Q(start__lte=today) & Q(end__gte=today))
        elif "is_coming" in self.data:
            query = query & Q(start__gt=today)
        elif "is_passed" in self.data:
            query = query & Q(result__lt=today)
        if "participated" in self.data:
            user_id = self.user.account_id
            if "other_user" in self.data:
                user_id = self.data["other_user"]
            query = query & Q(posts__account_id=user_id)
        if "tag" in self.data:
            annotate["tag_dist"] = Levenshtein("tag", self.data["tag"])
        if "name" in self.data:
            annotate["name_dist"] = Levenshtein("name", self.data["name"])

        ordering = []
        if "start" in self.data:
            ordering.append("-start" if self.data["start"] == 1 else "start")   # desc if 1
        elif "end" in self.data:
            ordering.append("-end" if self.data["end"] == 1 else "end")
        competitions: QuerySet = Competition.objects.prefetch_related('posts').select_related('user_host').filter(query)\
            .annotate(**annotate).order_by(*ordering)
        return competitions




