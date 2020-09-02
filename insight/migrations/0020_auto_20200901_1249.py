# Generated by Django 3.0.8 on 2020-09-01 12:49

import datetime
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0019_auto_20200829_1558'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='notification',
            name='accounts',
        ),
        migrations.RemoveField(
            model_name='notification',
            name='created',
        ),
        migrations.RemoveField(
            model_name='notification',
            name='id',
        ),
        migrations.RemoveField(
            model_name='notification',
            name='image',
        ),
        migrations.RemoveField(
            model_name='notification',
            name='notification_type',
        ),
        migrations.AddField(
            model_name='notification',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 1, 12, 49, 49, 245258, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='notification',
            name='noti_id',
            field=models.CharField(default='', max_length=35, primary_key=True, serialize=False),
        ),
        migrations.AddField(
            model_name='notification',
            name='read',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='notification',
            name='to',
            field=models.ForeignKey(default='account_id', on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='notification',
            name='type',
            field=models.CharField(default='ALERT', max_length=5),
        ),
        migrations.AlterField(
            model_name='account',
            name='joined_at',
            field=models.DateField(default=datetime.date(2020, 9, 1)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='loved_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 1, 12, 49, 49, 243228, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='actionstore',
            name='viewed_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 1, 12, 49, 49, 243369, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='leaderboard',
            name='end_date',
            field=models.DateField(default=datetime.date(2020, 9, 1)),
        ),
        migrations.AlterField(
            model_name='leaderboard',
            name='start_date',
            field=models.DateField(default=datetime.date(2020, 9, 1)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 1, 12, 49, 49, 238666, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 9, 1, 12, 49, 49, 249328, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='date_created',
            field=models.DateField(default=datetime.date(2020, 9, 1)),
        ),
        migrations.AlterField(
            model_name='useractionref',
            name='time_created',
            field=models.TimeField(default=datetime.time(18, 19, 49, 240803)),
        ),
        migrations.CreateModel(
            name='RankBadge',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('competition_name', models.TextField()),
                ('date_field', models.DateField(default=datetime.date(2020, 9, 1))),
                ('time_field', models.TimeField(default=datetime.time(18, 19, 49, 251335))),
                ('total', models.IntegerField(max_length=5)),
                ('rank', models.IntegerField(default=0, max_length=5)),
                ('score', models.DecimalField(decimal_places=3, default=0.0, max_digits=7)),
                ('account', models.ForeignKey(default='account_id', on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('hobby', models.ForeignKey(default='', on_delete=django.db.models.deletion.CASCADE, to='insight.Hobby')),
            ],
        ),
    ]