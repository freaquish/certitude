from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.contrib.gis.db import models as gis_models
# from django.contrib.gis.geos.point import Point
from django.contrib.postgres.fields import ArrayField, JSONField
from django.db import models
from rest_framework.authtoken.models import Token

from .utils import *


# Create your models here.

class AccountManager(BaseUserManager):

    def create_user(self, account_id, password, **extra_fields):
        account = self.model(account_id, **extra_fields)
        account.set_password(password)
        account.save()

    def create_superuser(self, account_id, password, **extra_fields):
        """
        Create and save a SuperUser with the given email and password.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        return self.create_user(account_id, password, **extra_fields)


class Account(AbstractBaseUser, PermissionsMixin):
    # emailId or phone number without country code
    account_id = models.CharField(
        max_length=20, default='account_id', primary_key=True)
    id_type = models.CharField(max_length=6, default='PHONE')  # PHONE or EMAIL
    joined_at = models.DateField(default=get_ist_date())
    username = models.CharField(
        max_length=30, default='', unique=True, db_index=True)
    first_name = models.CharField(max_length=30, default='')
    last_name = models.CharField(max_length=30, default='')
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    # All personal details such as phone number, email, address, school. organisation
    details = JSONField(default=dict)
    comfort_zones_text = ArrayField(models.CharField(
        max_length=70), default=list)  # names of landmarks as keywords
    # {'x,y':{x:coords.x,y:coords.y,hit:n}}
    activity_coords = JSONField(default=dict)
    avatar = models.TextField()
    places = ArrayField(models.TextField(), default=list)
    influencer = models.BooleanField(default=False)
    influencing_hobby = models.CharField(max_length=20, default='')
    hobby_map = JSONField(default=dict)  # {"code_name": E(action)}
    primary_hobby = models.CharField(max_length=20, default='')
    primary_weight = models.DecimalField(
        max_digits=4, decimal_places=2, default=0.00)
    follower_count = models.IntegerField(default=0)
    following_count = models.IntegerField(default=0)
    saves = ArrayField(models.CharField(max_length=30), default=list)
    friend_count = models.IntegerField(default=0)
    friend_requests = ArrayField(models.CharField(max_length=50), default=list)
    description = models.TextField()
    following = ArrayField(models.CharField(max_length=30), default=list)
    friend = ArrayField(models.CharField(max_length=30), default=list)
    current_coord = gis_models.PointField(
        default=Point(0, 0, srid=4326), srid=4326)
    new_notification = models.BooleanField(default=False)
    USERNAME_FIELD = 'account_id'
    REQUIRED_FIELDS = ('id_type', 'joined_at')

    objects = AccountManager()

    def insert_coords(self, inserted_coords: Point, saveData=True):
        coord_x, coord_y = inserted_coords
        insertion_required: bool = True
        for coord in self.activity_coords:
            point: dict = self.activity_coords[coord]
            if distance(inserted_coords, Point(point['x'], point['y'])) <= 1:
                self.activity_coords[coord]['hit'] += 1
                insertion_required = False
        if insertion_required:
            self.activity_coords[f'{inserted_coords[0]},{inserted_coords[1]}'] = {'x': inserted_coords[0],
                                                                                  'y': inserted_coords[1],
                                                                                  'hit': 1}
        self.current_coord = inserted_coords
        if saveData:
            self.save()


class Hobby(models.Model):
    code_name = models.CharField(max_length=30, default='', primary_key=True)
    name = models.CharField(max_length=40, default='')
    editors = ArrayField(models.CharField(max_length=30), default=list)
    limits = JSONField(default=dict)
    weight = models.DecimalField(max_digits=5, decimal_places=3, default=0.0)


class Post(models.Model):
    post_id = models.CharField(max_length=22, primary_key=True, default='')
    username = models.CharField(max_length=30, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    editor = models.CharField(max_length=14)
    hobby = models.ForeignKey(Hobby, on_delete=models.CASCADE, default='')
    assets = JSONField(default=dict)
    caption = models.TextField()
    hastags = ArrayField(models.CharField(max_length=20), default=list)
    last_activity_on = models.DateField(default=get_ist())
    atags = ArrayField(models.CharField(max_length=20), default=list)
    coords = gis_models.PointField(
        Point(0, 0, srid=4326), srid=4326, blank=True, null=True)
    action_count = JSONField(default=dict)
    created_at = models.DateTimeField(default=get_ist())
    rank = models.IntegerField(default=0)
    score = models.DecimalField(max_digits=7, decimal_places=3, default=0.0)


class ActionStore(models.Model):
    account_id = models.CharField(max_length=50, db_index=True, default='')
    post_id = models.CharField(max_length=25, db_index=True, default='')
    loved = models.BooleanField(default=False)
    loved_at = models.DateTimeField(default=get_ist())
    viewed = models.BooleanField(default=False)
    viewed_at = models.DateTimeField(default=get_ist())
    shared = models.BooleanField(default=False)
    saved = models.BooleanField(default=False)
    commented = models.BooleanField(default=True)
    # [competition_name]
    upvoted = ArrayField(models.TextField(), default=list)

    def update(self, **kwargs):
        for key in kwargs.keys():
            self.__dict__[key] = kwargs[key]
        self.save()


class Notification(models.Model):
    noti_id = models.CharField(max_length=35, primary_key=True, default='')
    type = models.CharField(max_length=5, default='ALERT')
    meta = JSONField(default=dict)
    header = models.TextField()
    created_at = models.DateTimeField(default=get_ist())
    body = models.TextField()
    to = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    read = models.BooleanField(default=False)
    used = models.BooleanField(default=False)


class Leaderboard(models.Model):
    duration_type = models.CharField(max_length=8, default='weekly')
    start_date = models.DateField(default=get_ist_date())
    end_date = models.DateField(default=get_ist_date())
    hobby = models.CharField(max_length=20, default='')
    hobby_name = models.CharField(max_length=30, default='')
    # rank: {account_id,score,name,influencer}
    rank_list = JSONField(default=dict)


class Tags(models.Model):
    tag = models.TextField(primary_key=True)
    created_at = models.DateTimeField(default=get_ist())
    first_used = models.CharField(max_length=22, default='')


class Places(models.Model):
    place_name = models.TextField()
    city = models.TextField()
    coords = gis_models.PointField(default=Point(0, 0), srid=4326)


class RankBadge(models.Model):
    competition_name = models.TextField()
    created_at = models.DateTimeField(default=get_ist())
    hobby = models.ForeignKey(Hobby, on_delete=models.CASCADE, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    total = models.IntegerField(default=0)
    rank = models.IntegerField(default=0)
    score = models.DecimalField(max_digits=7, decimal_places=3, default=0.0)


class UserPostComment(models.Model):
    post_id = models.CharField(max_length=22, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    comment = models.TextField()
    created_at = models.DateTimeField(default=get_ist())
    count = models.IntegerField(default=0)


"""

    LeaderBoard Competition, team and community models  

"""


class ScorePost(models.Model):
    score = models.DecimalField(max_digits=7, decimal_places=3, default=0.0)
    rank = models.IntegerField(default=0)
    post = models.ForeignKey(Post, on_delete=models.CASCADE, default='')
    hobby = models.CharField(max_length=30, default='', primary_key=True)
    created_at = models.DateTimeField(default=get_ist())
    last_modified = models.DateTimeField(default=get_ist())


class Scoreboard(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    created_at = models.DateField(default=get_ist_date())
    expires_on = models.DateField(default=get_ist_date())
    hobby_scores = JSONField(default=dict)
    net_score = models.DecimalField(
        default=0.0, max_digits=8, decimal_places=4)
    rank = models.IntegerField(default=0)


class Community(models.Model):
    community_id = models.CharField(
        max_length=26, primary_key=True, default='')
    name = models.TextField()
    tag = models.CharField(max_length=50, unique=True)
    description = models.TextField()
    hobbies = ArrayField(models.CharField(max_length=30), default=list)
    image = models.TextField()
    created_at = models.DateTimeField(default=get_ist())

    def edit(self, **data):
        for key in data.keys():
            self.__dict__[key] = data[key]
        self.save()


class CommunityMember(models.Model):
    created_at = models.DateTimeField(default=get_ist())
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, related_name='community', default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id', related_name='account')
    is_team_member = models.BooleanField(default=False)
    is_team_head = models.BooleanField(default=False)


class TeamMember(models.Model):
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id', related_name='account')
    assigned_at = models.DateTimeField(default=get_ist())
    position = models.TextField()
    description = models.TextField()
    is_head = models.BooleanField(default=False)
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, related_name='community', default='')

    def edit(self, **data):
        for key in data.keys():
            self.__dict__[key] = data[key]
        self.save()


class Competition(models.Model):
    competition_id = models.CharField(max_length=36, primary_key=True)
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, default='')
    name = models.TextField()
    tag = models.CharField(max_length=50, unique=True)
    description = models.TextField()
    competitions_banner = models.TextField()
    start_at = models.DateTimeField(default=get_ist())
    end_at = models.DateTimeField(default=get_ist())
    hobbies = ArrayField(models.CharField(max_length=30), default=list)
    is_global = models.BooleanField(default=False)
    result_date = models.DateTimeField(default=get_ist())
    is_unique_post = models.BooleanField(default=False)
    submission_per_user = models.IntegerField(default=0)
    rules_policy = models.TextField()
    number_post_submitted = models.IntegerField(default=0)


class CommunityPost(models.Model):
    post_id = models.CharField(max_length=22, default='')
    community = models.ForeignKey(
        Community, on_delete=models.CASCADE, default='')
    created_at = models.DateTimeField(default=get_ist())
