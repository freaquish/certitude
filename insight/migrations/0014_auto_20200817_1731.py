# Generated by Django 3.0.8 on 2020-08-17 17:31

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0013_auto_20200816_2149'),
    ]

    operations = [
        migrations.AlterField(
            model_name='actionstore',
            name='loved_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 17, 17, 31, 56, 953937, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='viewed_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 17, 17, 31, 56, 954184, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='notification',
            name='created',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 17, 17, 31, 56, 956591, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 17, 17, 31, 56, 946871, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 17, 17, 31, 56, 963474, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='time_created',
            field=models.TimeField(default=datetime.time(23, 1, 56, 949681)),
        ),
    ]
