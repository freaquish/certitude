# Generated by Django 3.0.8 on 2020-09-20 17:34

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0025_auto_20200918_1236'),
    ]

    operations = [
        migrations.AlterField(
            model_name='account',
            name='joined_at',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='loved_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 20, 17, 34, 21, 263627, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='viewed_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 20, 17, 34, 21, 263752, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='leaderboard',
            name='end_date',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='leaderboard',
            name='start_date',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='notification',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 20, 17, 34, 21, 265359, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 20, 17, 34, 21, 259337, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='last_activity_on',
            field=models.DateField(default=datetime.datetime(2020, 9, 20, 17, 34, 21, 258770, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankbadge',
            name='date_field',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='rankbadge',
            name='time_field',
            field=models.TimeField(default=datetime.time(23, 4, 21, 271810)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='created_at',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='expires_on',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 20, 17, 34, 21, 269371, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='first_used',
            field=models.CharField(default='', max_length=50),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='date_created',
            field=models.DateField(default=datetime.date(2020, 9, 20)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='time_created',
            field=models.TimeField(default=datetime.time(23, 4, 21, 261396)),
        ),
    ]
