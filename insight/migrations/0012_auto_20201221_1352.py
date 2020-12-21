# Generated by Django 3.0.5 on 2020-12-21 13:52

import datetime
from django.conf import settings
import django.contrib.postgres.fields
import django.contrib.postgres.fields.jsonb
from django.db import migrations, models
import django.db.models.deletion
from django.utils.timezone import utc
import djongo.models.fields
import insight.models


class Migration(migrations.Migration):

    dependencies = [
        ('insight', '0011_auto_20201130_0953'),
    ]

    operations = [
        migrations.CreateModel(
            name='Competition',
            fields=[
                ('key', models.CharField(db_index=True, max_length=27, primary_key=True, serialize=False)),
                ('tag', models.TextField(db_index=True, unique=True)),
                ('is_active', models.BooleanField(default=True)),
                ('start', models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 493036, tzinfo=utc))),
                ('end', models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 493058, tzinfo=utc))),
                ('result', models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 493074, tzinfo=utc))),
                ('images', django.contrib.postgres.fields.ArrayField(base_field=models.TextField(), default=list, size=None)),
                ('name', models.TextField()),
                ('details', django.contrib.postgres.fields.jsonb.JSONField(default=dict)),
                ('judged_by_user', models.BooleanField(default=False)),
                ('is_public_competition', models.BooleanField(default=True)),
                ('banned_users', django.contrib.postgres.fields.ArrayField(base_field=models.CharField(max_length=22), default=list, size=None)),
                ('banned_posts', django.contrib.postgres.fields.ArrayField(base_field=models.CharField(max_length=22), default=list, size=None)),
                ('hobbies', models.ManyToManyField(related_name='competition_hobby', to='insight.Hobby')),
            ],
        ),
        migrations.CreateModel(
            name='DownVoteActionModel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.CreateModel(
            name='LoveActionModel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.CreateModel(
            name='ShareActionModel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.CreateModel(
            name='UpVoteActionModel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.CreateModel(
            name='ViewActionModel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.DeleteModel(
            name='ActionStore',
        ),
        migrations.RenameField(
            model_name='rankreport',
            old_name='rank',
            new_name='current_rank',
        ),
        migrations.RenameField(
            model_name='rankreport',
            old_name='score',
            new_name='current_score',
        ),
        migrations.RemoveField(
            model_name='post',
            name='atags',
        ),
        migrations.RemoveField(
            model_name='post',
            name='hastags',
        ),
        migrations.RemoveField(
            model_name='rankreport',
            name='date',
        ),
        migrations.AddField(
            model_name='post',
            name='last_validity',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 486896, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='post',
            name='used_in_competition',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='rankreport',
            name='alive_from',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 496183, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='rankreport',
            name='competition_key',
            field=models.TextField(default=''),
        ),
        migrations.AddField(
            model_name='rankreport',
            name='created',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 496098, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='rankreport',
            name='expiry',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 496202, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='rankreport',
            name='tree',
            field=djongo.models.fields.ArrayField(model_container=insight.models.RankBranch, null=True),
        ),
        migrations.AlterField(
            model_name='account',
            name='joined_at',
            field=models.DateField(default=datetime.date(2020, 12, 21)),
        ),
        migrations.AlterField(
            model_name='post',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 486913, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='post',
            name='last_modified',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 486866, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='created_at',
            field=models.DateField(default=datetime.date(2020, 12, 21)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='expires_on',
            field=models.DateField(default=datetime.date(2020, 12, 21)),
        ),
        migrations.AlterField(
            model_name='scoreboard',
            name='original_creation',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 492240, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='tags',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 485960, tzinfo=utc)),
        ),
        migrations.AlterField(
            model_name='userpostcomment',
            name='created_at',
            field=models.DateTimeField(default=datetime.datetime(2020, 12, 21, 13, 52, 55, 486250, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='viewactionmodel',
            name='account',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='viewactionmodel',
            name='post',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='insight.Post'),
        ),
        migrations.AddField(
            model_name='upvoteactionmodel',
            name='account',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='upvoteactionmodel',
            name='post',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='insight.Post'),
        ),
        migrations.AddField(
            model_name='shareactionmodel',
            name='account',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='shareactionmodel',
            name='post',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='insight.Post'),
        ),
        migrations.AddField(
            model_name='loveactionmodel',
            name='account',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='loveactionmodel',
            name='post',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='insight.Post'),
        ),
        migrations.AddField(
            model_name='downvoteactionmodel',
            name='account',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='downvoteactionmodel',
            name='post',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='insight.Post'),
        ),
        migrations.AddField(
            model_name='competition',
            name='posts',
            field=models.ManyToManyField(blank=True, related_name='competition_posts', to='insight.Post'),
        ),
        migrations.AddField(
            model_name='competition',
            name='user_host',
            field=models.ForeignKey(default='', on_delete=django.db.models.deletion.CASCADE, related_name='competition_user_host', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterUniqueTogether(
            name='viewactionmodel',
            unique_together={('account', 'post')},
        ),
        migrations.AlterUniqueTogether(
            name='upvoteactionmodel',
            unique_together={('account', 'post')},
        ),
        migrations.AlterUniqueTogether(
            name='shareactionmodel',
            unique_together={('account', 'post')},
        ),
        migrations.AlterUniqueTogether(
            name='loveactionmodel',
            unique_together={('account', 'post')},
        ),
        migrations.AlterUniqueTogether(
            name='downvoteactionmodel',
            unique_together={('account', 'post')},
        ),
    ]
