from django.db import models
from django.contrib.gis.db import models as gis_models
from django.contrib.postgres.fields import ArrayField, JSONField
from .utils import *
from django.contrib.gis.geos.point import Point
from django.contrib.auth.base_user import AbstractBaseUser
from django.utils import timezone
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from rest_framework.authtoken.models import Token


# Create your models here.


class AccountManager(BaseUserManager):
    use_in_migrations: bool = True

    @staticmethod
    def sanitize_account_id(account_id: str, country_code: str):
        length: int = len(country_code)
        pre_sanitized: str = account_id.replace(" ", "")
        if '+' in pre_sanitized:
            return pre_sanitized[length:]
        else:
            return pre_sanitized

    def _create_account(self, account_id: str, id_type: str, password: str, is_staff: bool,
                        is_superuser: bool, country_code: str = '+91'):
        assert (account_id and id_type  and password), 'Incomplete Data'
        account: Account = self.model.objects.create(
            account_id=self.sanitize_account_id(account_id, country_code) if id_type == 'PHONE' else account_id,
            id_type=id_type, is_staff=is_staff, is_superuser=is_superuser
        )
        account.set_password(password)
        account.save()
        token: Token = Token.objects.create(user=account)
        return account,token

    def insert_coords(self, inserted_coords: Point, saveData=True):
        coord_x, coord_y = inserted_coords
        insertion_required: bool = True
        for coord in self.model.activity_coords:
            point: dict = self.model.activity_coords[coord]
            if distance(inserted_coords, Point(point['x'], point['y'])) <= 1:
                self.model.activity_coords[coord]['hit'] += 1
                insertion_required = False
        if insertion_required:
            self.model.activity_coords[f'{inserted_coords[0]},{inserted_coords[1]}'] = {'x': inserted_coords[0],
                                                                                        'y': inserted_coords[1],
                                                                                        'hit': 1}
        self.model.current_coord = inserted_coords                                                                                
        if saveData:
            self.model.save()

    def insert_hobby_map(self, hobby, saveData=True):
        self.model.hobby_map[hobby] = self.model.hobby_map[hobby] + 1 if hobby in self.model.hobby_map else 1
        max_hobby = [None,0]
        for key in self.model.hobby_map.keys():
            if self.model.hobby_map[key] > max_hobby[-1]:
                max_hobby = [key, self.model.hobby_map[key]]
        self.model.primary_hobby = max_hobby[0]
        hobby = Hobby.objects.get(pk=max_hobby[0])
        self.model.primary_weight = hobby.weight
        if saveData:
            self.model.save()

    def create_user_account(self, account_id: str, id_type: str, password: str,
                            country_code: str = '+91'):
        return self._create_account(account_id, id_type, password, False, False, country_code=country_code)

    def create_super_account(self, account_id: str, id_type: str, password: str, country_code: str = '+91'):
        return self._create_account(account_id, id_type, password, True, True, country_code=country_code)


class Account(AbstractBaseUser, PermissionsMixin):
    # emailId or phone number without country code
    account_id = models.CharField(max_length=50, default='account_id', primary_key=True)
    id_type = models.CharField(max_length=6, default='PHONE')  # PHONE or EMAIL
    joined_at = models.DateField(default=get_ist_date())
    username = models.CharField(max_length=30, default='', unique=True, db_index=True)
    first_name = models.CharField(max_length=30, default='')
    last_name = models.CharField(max_length=30, default='')
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    details = JSONField(default=dict)  # All personal details such as phone number, email, address, school. organisation
    comfort_zones_text = ArrayField(models.CharField(max_length=70), default=list)  # names of landmarks as keywords
    activity_coords = JSONField(default=dict)  # {'x,y':{x:coords.x,y:coords.y,hit:n}}
    # Hit is no of times the app recorded activity at this point: activities feed,post
    # Hit will be evaluated in 500m range, i.e if any coord is present in activity_coors which is in 1km range
    # of the instead coord than hit will increase rather than new coord
    avatar = models.TextField()
    influencer = models.BooleanField(default=False)
    influencing_hobby = models.CharField(max_length=20, default='')
    hobby_map = JSONField(default=dict)
    primary_hobby = models.CharField(max_length=20, default='')
    primary_weight = models.DecimalField(max_digits=4, decimal_places=2, default=0.00)
    follower_count = models.IntegerField(default=0)
    following_count = models.IntegerField(default=0)
    saves = ArrayField(models.CharField(max_length=30), default=list)
    friend_count = models.IntegerField(default=0)
    friend_requests = ArrayField(models.CharField(max_length=50), default=list)
    description = models.TextField()
    following = ArrayField(models.CharField(max_length=30), default=list)
    friend = ArrayField(models.CharField(max_length=30), default=list)
    current_coord = gis_models.PointField(default=Point(0, 0, srid=4326), srid=4326)
    objects = AccountManager()
    new_notification = models.BooleanField(default=False)
    USERNAME_FIELD = 'account_id'
    REQUIRED_FIELDS = ('id_type', 'joined_at')


class Hobby(models.Model):
    code_name = models.CharField(max_length=20, default='', primary_key=True)
    name = models.CharField(max_length=30, default='')
    editors = ArrayField(models.CharField(max_length=10), default=list)
    limits = JSONField(default=dict)
    weight = models.DecimalField(max_digits=3, decimal_places=2, default=0.0)


class Post(models.Model):
    post_id = models.CharField(max_length=15, primary_key=True, default='')
    username = models.CharField(max_length=30, default='')
    account_id = models.CharField(max_length=50)
    avatar = models.TextField()
    editor = models.CharField(max_length=10)
    hobby = models.CharField(max_length=20, default='')
    hobby_name = models.CharField(max_length=30, default='')
    hobby_weight = models.DecimalField(max_digits=4, decimal_places=2, default=0.00)
    assets = JSONField(default=dict)
    caption = models.TextField()
    hastags = ArrayField(models.CharField(max_length=20), default=list)
    atags = ArrayField(models.CharField(max_length=20), default=list)
    coords = gis_models.PointField(Point(0, 0, srid=4326), srid=4326)
    action_count = JSONField(default=dict)
    created_at = models.DateTimeField(default=get_ist())
    rank = models.IntegerField(default=0)
    score = models.DecimalField(max_digits=7, decimal_places=3, default=0.0)


class UserActionRef(models.Model):
    account_id = models.CharField(max_length = 50, default= '')
    date_created = models.DateField(default=get_ist_date())
    time_created = models.TimeField(default=get_ist_time())
    hobby = models.CharField(max_length=20, default='')
    loves = ArrayField(models.CharField(max_length=30), default=list)
    shares = ArrayField(models.CharField(max_length=30), default=list)
    saves = ArrayField(models.CharField(max_length=30), default=list)
    comments = ArrayField(models.CharField(max_length=30), default=list)
    views = ArrayField(models.CharField(max_length=30), default=list)


class Notification(models.Model):
    accounts = ArrayField(models.CharField(max_length=50), default=list)
    created = models.DateTimeField(default=get_ist())
    notification_type = models.CharField(max_length=20, default=GENERAL_ACTIVITY)
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
    rank_list = JSONField(default=dict)  # rank: {account_id,score,name,influencer}


class Tags(models.Model):
    tag = models.TextField(primary_key=True)
    created_at = models.DateTimeField(default=get_ist())
    first_used = models.CharField(max_length=15, default='')
