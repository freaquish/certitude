# Generated by Django 3.0.5 on 2020-12-27 16:46

import datetime
from django.db import migrations, models
from django.utils.timezone import utc
import djongo.models.fields
import insight.models


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0017_auto_20201227_1613'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='datalog',
            name='body',
        ),
        migrations.RemoveField(
            model_name='datalog',
            name='headers',
        ),
        migrations.RemoveField(
            model_name='datalog',
            name='process',
        ),
        migrations.AddField(
            model_name='datalog',
            name='logs',
            field=djongo.models.fields.ArrayField(default=list, model_container=insight.models.LogJsonData),
        ),
        migrations.AlterField(
            model_name='competition',
            name='end',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 420417, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='competition',
            name='result',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 420437, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='competition',
            name='start',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 420397, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='datalog',
            name='created_at',
            field=models.DateField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 422639, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='alive_from',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 415767, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 415783, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='last_validity',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 415745, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankreport',
            name='alive_from',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 421774, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankreport',
            name='created',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 421712, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='rankreport',
            name='expiry',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 421790, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='original_creation',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 419622, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 414880, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='userpostcomment',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 27, 16, 46, 7, 415173, tzinfo=utc)),
        ),
    ]