from django.conf import settings
import json
import os
from insight.models import *

def load_data(filename):
    path = os.path.join(settings.BACKUP_DIR,filename)
    return json.load(open(path))

def load_post(filename):
    loaded = load_data(filename)
    for js in loaded:
        print(js)
        post = Post.objects.get(pk=js['pk'])
        account = Account.objects.get(pk=js['fields']['account_id'])
        hobby = Hobby.objects.get(pk=js['fields']['hobby'])
        post.account = account
        post.hobby = hobby
        post.save()
