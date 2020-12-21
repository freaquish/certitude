# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.contrib.gis.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthtokenToken(models.Model):
    key = models.CharField(primary_key=True, max_length=40)
    created = models.DateTimeField()
    user = models.OneToOneField('InsightAccount', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'authtoken_token'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey('InsightAccount', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class InsightAccount(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    account_id = models.CharField(primary_key=True, max_length=20)
    id_type = models.CharField(max_length=6)
    joined_at = models.DateField()
    username = models.CharField(unique=True, max_length=30)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    is_staff = models.BooleanField()
    is_superuser = models.BooleanField()
    is_active = models.BooleanField()
    details = django.contrib.postgres.fields.JSONField()
    comfort_zones_text = models.TextField()  # This field type is a guess.
    activity_coords = django.contrib.postgres.fields.JSONField()
    avatar = models.TextField()
    places = models.TextField()  # This field type is a guess.
    hobby_map = django.contrib.postgres.fields.JSONField()
    primary_hobby = models.CharField(max_length=20)
    primary_weight = models.DecimalField(max_digits=4, decimal_places=2)
    follower_count = models.IntegerField()
    following_count = models.IntegerField()
    description = models.TextField()
    following = models.TextField()  # This field type is a guess.
    current_coord = models.PointField()
    new_notification = models.BooleanField()
    country_code = models.CharField(max_length=4)

    class Meta:
        managed = False
        db_table = 'insight_account'


class InsightAccountGroups(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_account_groups'
        unique_together = (('account', 'group'),)


class InsightAccountUserPermissions(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_account_user_permissions'
        unique_together = (('account', 'permission'),)


class InsightCompetition(models.Model):
    key = models.CharField(primary_key=True, max_length=27)
    tag = models.TextField(unique=True)
    is_active = models.BooleanField()
    start = models.DateTimeField()
    end = models.DateTimeField()
    result = models.DateTimeField()
    images = models.TextField()  # This field type is a guess.
    name = models.TextField()
    details = django.contrib.postgres.fields.JSONField()
    judged_by_user = models.BooleanField()
    is_public_competition = models.BooleanField()
    banned_users = models.TextField()  # This field type is a guess.
    banned_posts = models.TextField()  # This field type is a guess.
    user_host = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_competition'


class InsightCompetitionHobbies(models.Model):
    competition = models.ForeignKey(InsightCompetition, models.DO_NOTHING)
    hobby = models.ForeignKey('InsightHobby', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_competition_hobbies'
        unique_together = (('competition', 'hobby'),)


class InsightCompetitionPosts(models.Model):
    competition = models.ForeignKey(InsightCompetition, models.DO_NOTHING)
    post = models.ForeignKey('InsightPost', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_competition_posts'
        unique_together = (('competition', 'post'),)


class InsightDownvoteactionmodel(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    post = models.ForeignKey('InsightPost', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_downvoteactionmodel'
        unique_together = (('account', 'post'),)


class InsightHobby(models.Model):
    code_name = models.CharField(primary_key=True, max_length=30)
    name = models.CharField(max_length=40)
    editors = models.TextField()  # This field type is a guess.
    limits = django.contrib.postgres.fields.JSONField()
    weight = models.DecimalField(max_digits=5, decimal_places=3)

    class Meta:
        managed = False
        db_table = 'insight_hobby'


class InsightHobbyreport(models.Model):
    views = models.IntegerField()
    loves = models.IntegerField()
    shares = models.IntegerField()
    comments = models.IntegerField()
    communities_involved = models.IntegerField()
    competition_participated = models.IntegerField()
    competition_hosted = models.IntegerField()
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    hobby = models.ForeignKey(InsightHobby, models.DO_NOTHING)
    posts = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'insight_hobbyreport'


class InsightLoveactionmodel(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    post = models.ForeignKey('InsightPost', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_loveactionmodel'
        unique_together = (('account', 'post'),)


class InsightPlaces(models.Model):
    place_name = models.TextField()
    city = models.TextField()
    coordinates = models.PointField()

    class Meta:
        managed = False
        db_table = 'insight_places'


class InsightPost(models.Model):
    post_id = models.CharField(primary_key=True, max_length=22)
    assets = django.contrib.postgres.fields.JSONField()
    caption = models.TextField()
    coordinates = models.PointField(blank=True, null=True)
    action_count = django.contrib.postgres.fields.JSONField()
    created_at = models.DateTimeField()
    rank = models.IntegerField()
    is_global = models.BooleanField()
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    hobby = models.ForeignKey(InsightHobby, models.DO_NOTHING)
    freshness_score = models.DecimalField(max_digits=7, decimal_places=4)
    last_modified = models.DateTimeField()
    net_score = models.DecimalField(max_digits=7, decimal_places=4)
    score = models.DecimalField(max_digits=7, decimal_places=4)
    last_validity = models.DateTimeField()
    used_in_competition = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'insight_post'


class InsightPostATags(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    tags = models.ForeignKey('InsightTags', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_a_tags'
        unique_together = (('post', 'tags'),)


class InsightPostComments(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    userpostcomment = models.ForeignKey('InsightUserpostcomment', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_comments'
        unique_together = (('post', 'userpostcomment'),)


class InsightPostDownVotes(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_down_votes'
        unique_together = (('post', 'account'),)


class InsightPostHashTags(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    tags = models.ForeignKey('InsightTags', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_hash_tags'
        unique_together = (('post', 'tags'),)


class InsightPostLoves(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_loves'
        unique_together = (('post', 'account'),)


class InsightPostShares(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_shares'
        unique_together = (('post', 'account'),)


class InsightPostUpVotes(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_up_votes'
        unique_together = (('post', 'account'),)


class InsightPostViews(models.Model):
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_post_views'
        unique_together = (('post', 'account'),)


class InsightScoreboard(models.Model):
    created_at = models.DateField()
    expires_on = models.DateField()
    retention = models.DecimalField(max_digits=9, decimal_places=5)
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    original_creation = models.DateTimeField()
    down_votes = models.IntegerField()
    loves = models.IntegerField()
    shares = models.IntegerField()
    up_votes = models.IntegerField()
    views = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'insight_scoreboard'


class InsightScoreboardPosts(models.Model):
    scoreboard = models.ForeignKey(InsightScoreboard, models.DO_NOTHING)
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_scoreboard_posts'
        unique_together = (('scoreboard', 'post'),)


class InsightShareactionmodel(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_shareactionmodel'
        unique_together = (('account', 'post'),)


class InsightTags(models.Model):
    tag = models.TextField(primary_key=True)
    created_at = models.DateTimeField()
    first_used = models.CharField(max_length=22)
    tag_type = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'insight_tags'


class InsightUpvoteactionmodel(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_upvoteactionmodel'
        unique_together = (('account', 'post'),)


class InsightUserpostcomment(models.Model):
    post_id = models.CharField(max_length=22)
    comment = models.TextField()
    created_at = models.DateTimeField()
    count = models.IntegerField()
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_userpostcomment'


class InsightViewactionmodel(models.Model):
    account = models.ForeignKey(InsightAccount, models.DO_NOTHING)
    post = models.ForeignKey(InsightPost, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'insight_viewactionmodel'
        unique_together = (('account', 'post'),)
