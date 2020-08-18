# Generated by Django 3.0.8 on 2020-08-16 15:27

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0010_auto_20200816_1523'),
    ]

    operations = [
        migrations.AlterField(
            model_name='actionstore',
            name='loved_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 16, 15, 27, 7, 748624, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='viewed_at',
            field=models.DateField(default=datetime.datetime(2020, 8, 16, 15, 27, 7, 748855, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='hobby',
            name='code_name',
            field=models.CharField(default='', max_length=30, primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='notification',
            name='created',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 16, 15, 27, 7, 751188, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 16, 15, 27, 7, 741740, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='editor',
            field=models.CharField(max_length=14),
        ),
        migrations.AlterField(
            model_name='post',
            name='hobby',
            field=models.CharField(default='', max_length=30),
        ),
        migrations.AlterField(
            model_name='post',
            name='hobby_name',
            field=models.CharField(default='', max_length=40),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 8, 16, 15, 27, 7, 757596, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='time_created',
            field=models.TimeField(default=datetime.time(20, 57, 7, 744644)),
        ),
    ]
