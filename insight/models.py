from django.db import models
from django.contrib.gis.db import models as gis_models
from django.contrib.postgres.fields import ArrayField, JSONField
from .utils import *
from django.contrib.gis.geos.point import Point
from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from rest_framework.authtoken.models import Token
from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank


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
            raise ValueError(_('Superuser must have is_staff=True.'))
        if extra_fields.get('is_superuser') is not True:
            raise ValueError(_('Superuser must have is_superuser=True.'))
        return self.create_user(account_id, password, **extra_fields)


class Account(AbstractBaseUser, PermissionsMixin):
    # emailId or phone number without country code
    account_id = models.CharField(
        max_length=50, default='account_id', primary_key=True)
    id_type = models.CharField(max_length=6, default='PHONE')  # PHONE or EMAIL
    joined_at = models.DateField(default=get_ist_date())
    username = models.CharField(
        max_length=30, default='', unique=True, db_index=True)
    first_name = models.CharField(max_length=30, default='')
    last_name = models.CharField(max_length=30, default='')
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)
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
    # account_id = models.CharField(max_length=50, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    editor = models.CharField(max_length=14)
    # hobby = models.CharField(max_length=30, default='')
    hobby = models.ForeignKey(Hobby, on_delete=models.CASCADE, default='')
    assets = JSONField(default=dict)
    caption = models.TextField()
    hastags = ArrayField(models.CharField(max_length=20), default=list)
    atags = ArrayField(models.CharField(max_length=20), default=list)
    coords = gis_models.PointField(
        Point(0, 0, srid=4326), srid=4326, blank=True, null=True)
    action_count = JSONField(default=dict)
    created_at = models.DateTimeField(default=get_ist())
    rank = models.IntegerField(default=0)
    score = models.DecimalField(max_digits=7, decimal_places=3, default=0.0)


class UserActionRef(models.Model):
    account_id = models.CharField(max_length=50, default='')
    date_created = models.DateField(default=get_ist_date())
    time_created = models.TimeField(default=get_ist_time())
    hobby = models.CharField(max_length=20, default='')
    loves = ArrayField(models.CharField(max_length=30), default=list)
    shares = ArrayField(models.CharField(max_length=30), default=list)
    saves = ArrayField(models.CharField(max_length=30), default=list)
    comments = ArrayField(models.CharField(max_length=30), default=list)
    views = ArrayField(models.CharField(max_length=30), default=list)


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
    accounts = ArrayField(models.CharField(max_length=50), default=list)
    created = models.DateTimeField(default=get_ist())
    notification_type = models.CharField(
        max_length=20, default=GENERAL_ACTIVITY)
    header = models.TextField()
    body = models.TextField()
    image = models.TextField()
    meta = JSONField(default=dict)


class PostComment(models.Model):
    post_id = models.CharField(max_length=15)
    comments = ArrayField(JSONField(), default=list)


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
    first_used = models.CharField(max_length=15, default='')


class Places(models.Model):
    place_name = models.TextField()
    city = models.TextField()


class RankBadge(models.Model):
    competition_name = models.TextField()
    created_at = models.DateTimeField(default=get_ist())
    hobby = models.ForeignKey(Hobby, on_delete=models.CASCADE, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    total = models.IntegerField(max_length=5)
    rank = models.IntegerField(max_length=5, default=0)
    score = models.DecimalField(max_digits=7, decimal_places=3, default=0.0)
