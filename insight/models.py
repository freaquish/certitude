from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.contrib.gis.db import models as gis_models
# from django.contrib.gis.geos.point import Point
from django.contrib.postgres.fields import ArrayField, JSONField
from django.db import models
from django.db.models import QuerySet, Q
from djongo import models as mongo_models

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
    country_code = models.CharField(max_length=4, default='+91')
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
    hobby_map = JSONField(default=dict)  # {"code_name": E(action)}
    primary_hobby = models.CharField(max_length=20, default='')
    primary_weight = models.DecimalField(
        max_digits=4, decimal_places=2, default=0.00)
    follower_count = models.IntegerField(default=0)
    following_count = models.IntegerField(default=0)
    # saves = ArrayField(models.CharField(max_length=30), default=list)
    description = models.TextField()
    following = ArrayField(models.CharField(max_length=30), default=list)
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


class HobbyReport(models.Model):
    account = models.ForeignKey(Account, related_name='hobby_report_account', on_delete=models.CASCADE)
    hobby = models.ForeignKey(Hobby, related_name='hobby_report_hobby', on_delete=models.CASCADE)
    posts = models.IntegerField(default=0)
    views = models.IntegerField(default=0)
    loves = models.IntegerField(default=0)
    shares = models.IntegerField(default=0)
    comments = models.IntegerField(default=0)
    communities_involved = models.IntegerField(default=0)
    competition_hosted = models.IntegerField(default=0)
    competition_participated = models.IntegerField(default=0)
    competition_hosted = models.IntegerField(default=0)


HASH = 'HASH'
A_TAG = 'A_TAG'


class TagsManager(models.Manager):

    def create(self, **kwargs):
        tag_type: str = ''
        tag: str = kwargs['tag']
        if '#' in kwargs['tag']:
            tag_type = HASH
            tag = kwargs['tag'].replace('#', '')
        elif '@' in kwargs['tag']:
            tag_type = A_TAG
            tag = kwargs['tag'].replace('@', '')
        kwargs['tag'] = tag
        kwargs['tag_type'] = tag_type
        kwargs['created_at'] = get_ist()
        tag = self.model(**kwargs)
        tag.save()
        return tag


class Tags(models.Model):
    tag = models.TextField(primary_key=True)
    created_at = models.DateTimeField(default=get_ist())
    tag_type = models.CharField(max_length=10, default=HASH)
    first_used = models.CharField(max_length=22, default='')

    objects = TagsManager()


class UserPostComment(models.Model):
    post_id = models.CharField(max_length=22, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    comment = models.TextField()
    created_at = models.DateTimeField(default=get_ist())
    count = models.IntegerField(default=0)


class Post(models.Model):
    post_id = models.CharField(max_length=22, primary_key=True, default='')
    account = models.ForeignKey(
        Account, on_delete=models.CASCADE, default='account_id')
    hobby = models.ForeignKey(Hobby, on_delete=models.CASCADE, default='')
    assets = JSONField(default=dict)
    caption = models.TextField()
    hash_tags = models.ManyToManyField(Tags, blank=True, related_name='hash_tags_post', default='')
    a_tags = models.ManyToManyField(Tags, blank=True, related_name='a_tags_post', default='')
    coordinates = gis_models.PointField(
        Point(0, 0, srid=4326), srid=4326, blank=True, null=True)
    action_count = JSONField(default=dict)
    views = models.ManyToManyField(Account, through='ViewActionModel', blank=True,
                                   related_name='views_post', default='')
    loves = models.ManyToManyField(Account, through='LoveActionModel', blank=True,
                                   related_name='loves_post', default='')
    shares = models.ManyToManyField(Account, through='ShareActionModel', blank=True,
                                    related_name='shares_post', default='')
    up_votes = models.ManyToManyField(Account, through='UpVoteActionModel', blank=True,
                                      related_name='up_votes_post', default='')
    down_votes = models.ManyToManyField(Account, through='DownVoteActionModel', blank=True,
                                        related_name='down_votes_post', default='')
    comments = models.ManyToManyField(UserPostComment, blank=True,
                                      related_name='comments_post', default='')
    score = models.DecimalField(max_digits=7, decimal_places=4, default=0.0)
    freshness_score = models.DecimalField(max_digits=7, decimal_places=4, default=0.0)
    net_score = models.DecimalField(max_digits=7, decimal_places=4, default=0.0)
    used_in_competition = models.BooleanField(default=False)
    last_validity = models.DateTimeField(default=get_ist())
    alive_from = models.DateTimeField(default=get_ist())
    created_at = models.DateTimeField(default=get_ist())
    is_global = models.BooleanField(default=True)

    def __getitem__(self, item):
        return getattr(self, item, None)

    def view_add(self, *value):
        new_users = set(value).difference(tuple(self.views.through.objects.filter(Q(account_id__in=value) &
                                        Q(post_id=self.post_id)).values_list('account_id', flat=True)))
        self.views.through.objects.bulk_create(
            [ViewActionModel(post_id=self.post_id,
                             account_id=val) for val in new_users])

    def love_add(self, *value):
        users_in_db = self.loves.through.objects.filter(Q(account_id__in=value) & Q(post_id=self.post_id))
        users_in_db_accounts = users_in_db.values_list('account_id', flat=True)
        new_users = set(value).difference(tuple(users_in_db_accounts))
        users_in_db.delete()
        self.loves.through.objects.bulk_create(
            [LoveActionModel(post_id=self.post_id,
                             account_id=val) for val in new_users])

    def share_add(self, *value):
        self.shares.through.objects.bulk_create(
            [ShareActionModel(post_id=self.post_id,
                              account_id=val) for val in value])

    def up_vote_add(self, *value):
        self.up_votes.through.objects.bulk_create(
            [UpVoteActionModel(post_id=self.post_id,
                               account_id=val) for val in
             value])

    def down_vote_add(self, *value):
        self.down_votes.through.objects.bulk_create(
            [DownVoteActionModel(post_id=self.post_id,
                                 account_id=val) for val in
             value])

    def filter(self, **kwargs):
        data = {}
        g_key = None
        refs = {"views": "viewactionmodel", "loves": "loveactionmodel", "shares": "shareactionmodel",
                "up_votes": "upvoteactionmodel", "down_votes": "downvoteactionmodel"}
        keys = refs.keys()
        for key, value in kwargs.items():
            args = key.split('__')
            if args[0] in keys:
                if g_key is None:
                    g_key = args[0]
                elif g_key != args[0]:
                    continue
                data[key.replace(g_key, refs[g_key])] = value
            else:
                data[key] = value
        return self[g_key].filter(**data) if g_key else None


class LoveActionModel(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now=get_ist())

    class Meta:
        unique_together = (('account', 'post'),)


class ViewActionModel(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now=get_ist())

    class Meta:
        unique_together = (('account', 'post'),)


class ShareActionModel(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now=get_ist())

    class Meta:
        unique_together = (('account', 'post'),)


class UpVoteActionModel(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now=get_ist())

    class Meta:
        unique_together = (('account', 'post'),)


class DownVoteActionModel(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    created = models.DateTimeField(auto_now=get_ist())

    class Meta:
        unique_together = (('account', 'post'),)


class Places(models.Model):
    place_name = models.TextField()
    city = models.TextField()
    coordinates = gis_models.PointField(default=Point(0, 0), srid=4326)


"""

    LeaderBoard Competition, team and community models  

"""


class Scoreboard(models.Model):
    account = models.ForeignKey(Account, on_delete=models.CASCADE)
    created_at = models.DateField(default=get_ist_date())
    original_creation = models.DateTimeField(default=get_ist())
    expires_on = models.DateField(default=get_ist_date())
    posts = models.ManyToManyField(Post, blank=True, related_name='scoreboard_posts', default='')
    views = models.IntegerField(default=0)
    loves = models.IntegerField(default=0)
    shares = models.IntegerField(default=0)
    up_votes = models.IntegerField(default=0)
    down_votes = models.IntegerField(default=0)
    retention = models.DecimalField(max_digits=9, decimal_places=5, default=0.0)


class Competition(models.Model):
    key = models.CharField(max_length=27, primary_key=True, db_index=True)
    tag = models.TextField(unique=True, db_index=True)
    is_active = models.BooleanField(default=True)
    start = models.DateTimeField(default=get_ist())
    end = models.DateTimeField(default=get_ist())
    result = models.DateTimeField(default=get_ist())
    images = ArrayField(models.TextField(), default=list)
    hobbies = models.ManyToManyField(Hobby, related_name="competition_hobby")
    name = models.TextField()
    details = JSONField(default=dict)
    user_host = models.ForeignKey(Account, related_name='competition_user_host', default='', on_delete=models.CASCADE)
    # Judged by the hosts
    judged_by_user = models.BooleanField(default=False)
    is_public_competition = models.BooleanField(default=True)
    posts = models.ManyToManyField(Post, related_name='competition_posts', blank=True)
    banned_users = ArrayField(models.CharField(max_length=22), default=list)
    banned_posts = ArrayField(models.CharField(max_length=22), default=list)

    def append_post(self, post: Post):
        if post.post_id not in self.banned_posts and post.account_id not in self.banned_users:
            self.posts.add(post)

    def ban_user(self, account_id: str):
        if account_id not in self.banned_users:
            self.banned_users.append(account_id)
            self.save()

    def ban_post(self, post: Post):
        if post.post_id not in self.banned_posts:
            self.banned_posts.append(post.post_id)
            self.save()


class RankReport(models.Model):
    """
    Structure to trace change in rank and position in a competition
    RankReport will stop logging after crossing expiry date
    Expiry date will be updated if result date of competition is changed
    Currently using postgres but plans to use mongo
    """
    user = models.ForeignKey(Account, on_delete=models.CASCADE, default='', related_name='competition_user')
    created = models.DateTimeField(default=get_ist())
    tree = ArrayField(JSONField(), default=list)
    current_rank = models.IntegerField(default=0)
    current_score = models.DecimalField(max_digits=8, decimal_places=4)
    competition_key = models.TextField(default='')
    alive_from = models.DateTimeField(default=get_ist())
    expiry = models.DateTimeField(default=get_ist())
    result_declared = models.BooleanField(default=False)


"""
Mongo Database Models 
"""


class TextData(mongo_models.Model):
    text = mongo_models.TextField()

    class Meta:
        required_db_vendor = 'insight_story'
        abstract = True


class CoordinatesData(mongo_models.Model):
    x = mongo_models.DecimalField(default=0.0, max_digits=8, decimal_places=6)
    y = mongo_models.DecimalField(default=0.0, max_digits=8, decimal_places=6)

    class Meta:
        required_db_vendor = 'insight_story'
        abstract = True


class JsonData(mongo_models.Model):
    data = mongo_models.JSONField()

    class Meta:
        required_db_vendor = 'insight_story'
        abstract = True


class LogJsonData(mongo_models.Model):
    header = mongo_models.JSONField(default=dict)
    body = mongo_models.TextField()
    process = mongo_models.TextField()

    class Meta:
        required_db_vendor = 'insight_story'
        abstract = True


class DataLog(mongo_models.Model):
    user_id = mongo_models.TextField(default='', primary_key=True)
    created_at = mongo_models.DateField(default=get_ist())
    logs = mongo_models.ArrayField(model_container=LogJsonData, default=list)

    objects = mongo_models.DjongoManager()

    class Meta:
        required_db_vendor = 'insight_story'


class RankBranch(mongo_models.Model):
    rank = mongo_models.IntegerField()
    score = mongo_models.DecimalField(max_digits=8, decimal_places=4)
    logged_on = mongo_models.DateTimeField(default=get_ist())

    class Meta:
        required_db_vendor = 'insight_story'
        abstract = True


class HobbyNearest(mongo_models.Model):
    users_primary_hobby = mongo_models.TextField()
    chosen_hobby = mongo_models.TextField()
    source = mongo_models.TextField()
    is_recommended = mongo_models.BooleanField(default=False)

    objects = mongo_models.DjongoManager()

    class Meta:
        required_db_vendor = 'insight_story'


class NotificationBody(mongo_models.Model):
    account_id = mongo_models.CharField(max_length=50, default='')
    username = mongo_models.TextField(default='')
    body = mongo_models.TextField(default='')
    # has_seen = mongo_models.BooleanField(default=False)
    avatar = mongo_models.TextField(default='')
    time_stamp = mongo_models.DateTimeField(default=get_ist())
    intent = mongo_models.TextField(default='')
    intent_param = mongo_models.TextField(default='')

    class Meta:
        required_db_vendor = 'insight_story'
        abstract = True


class Notification(mongo_models.Model):
    account_id = mongo_models.CharField(max_length=50, default='', primary_key=True)
    notifications = mongo_models.ArrayField(model_container=NotificationBody)
    anyNew = mongo_models.BooleanField(default=False)

    objects = mongo_models.DjongoManager()

    class Meta:
        required_db_vendor = 'insight_story'