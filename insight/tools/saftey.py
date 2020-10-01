from celery import shared_task
from insight.models import Post, Tags 
from django.db.models import Q


@shared_task 
def safeguard_post_tags(tags):
    query = None 
    for tag in tags:
        if query:
            query = query | Q(tag=tag)
        else:
            query  =Q(tag=tag)
    tags_in_db = Tags.objects.filter(query)
    if len(tag) == len(tags_in_db):
        return None 


