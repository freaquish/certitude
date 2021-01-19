# Generated by Django 3.0.5 on 2020-12-21 13:56

import datetime
from django.conf import settings
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0013_auto_20201221_1356'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='down_votes',
            field=models.ManyToManyField(blank=True, default='', related_name='down_votes_post', through='insight.DownVoteActionModel', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='post',
            name='loves',
            field=models.ManyToManyField(blank=True, default='', related_name='loves_post', through='insight.LoveActionModel', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='post',
            name='shares',
            field=models.ManyToManyField(blank=True, default='', related_name='shares_post', through='insight.ShareActionModel', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='post',
            name='up_votes',
            field=models.ManyToManyField(blank=True, default='', related_name='up_votes_post', through='insight.UpVoteActionModel', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='post',
            name='views',
            field=models.ManyToManyField(blank=True, default='', related_name='views_post', through='insight.ViewActionModel', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='competition',
            name='end',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 706775, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='competition',
            name='result',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 706791, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='competition',
            name='start',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 706751, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 702369, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='last_modified',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 702320, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='last_validity',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 702351, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankreport',
            name='alive_from',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 709218, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankreport',
            name='created',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 709144, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankreport',
            name='expiry',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 709237, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='original_creation',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 705883, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 701412, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='userpostcomment',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 56, 20, 701696, tzinfo=utc)),
        ),
    ]