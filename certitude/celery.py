from __future__ import absolute_import, unicode_literals
import os
from celery import Celery
from celery.schedules import crontab
# from django_celery_beat.models import IntervalSchedule, PeriodicTask

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'certitude.settings')

app = Celery('certitude')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
app.conf.timezone = 'Asia/Kolkata'

app.conf.beat_schedule = {
    'periodic-ranking-every-day': {
        'task': 'insight.competitions.main.periodic_task',
        'schedule': crontab(hour='12'),
        'args': ()
    }
}


@app.task(bind=True)
def debug_task(self):
    print('Request: {0!r}'.format(self.request))
