# Generated by Django 3.0.8 on 2020-09-18 12:36

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0024_auto_20200912_1525'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='last_activity_on',
            field=models.DateField(default=datetime.datetime(2020, 9, 18, 12, 36, 49, 853105, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='account',
            name='joined_at',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='loved_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 18, 12, 36, 49, 858157, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='viewed_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 18, 12, 36, 49, 858287, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='leaderboard',
            name='end_date',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='leaderboard',
            name='start_date',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='notification',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 18, 12, 36, 49, 859872, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 18, 12, 36, 49, 853663, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankbadge',
            name='date_field',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='rankbadge',
            name='time_field',
            field=models.TimeField(default=datetime.time(18, 6, 49, 866373)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='created_at',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='expires_on',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 18, 12, 36, 49, 863923, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='date_created',
            field=models.DateField(default=datetime.date(2020, 9, 18)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='time_created',
            field=models.TimeField(default=datetime.time(18, 6, 49, 855821)),
        ),
    ]