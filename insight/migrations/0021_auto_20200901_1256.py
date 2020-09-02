# Generated by Django 3.0.8 on 2020-09-01 12:56

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0020_auto_20200901_1249'),
    ]

    operations = [
        migrations.AlterField(
            model_name='account',
            name='is_active',
            field=models.BooleanField(default=True),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='loved_at',
            field=models.DateTimeField(default=datetime.datetime(
                2020, 9, 1, 12, 56, 13, 999113, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='viewed_at',
            field=models.DateTimeField(default=datetime.datetime(
                2020, 9, 1, 12, 56, 13, 999254, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='notification',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(
                2020, 9, 1, 12, 56, 14, 1041, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(
                2020, 9, 1, 12, 56, 13, 994719, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankbadge',
            name='time_field',
            field=models.TimeField(default=datetime.time(18, 26, 14, 7447)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(
                2020, 9, 1, 12, 56, 14, 5457, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='time_created',
            field=models.TimeField(default=datetime.time(18, 26, 13, 996823)),
        ),
    ]