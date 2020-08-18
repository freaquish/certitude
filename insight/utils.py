from django.contrib.gis.geos.point import Point
from datetime import datetime, date, time
from secrets import token_urlsafe
from pytz import timezone


def distance(coorda: Point, coordb: Point):
    return coorda.distance(coordb) * 100


def json_to_coord(data: dict):
    if 'long' in data:
        return Point(data['lat'], data['long'])
    elif 'longitude' in data:
        return Point(data['longitude'], data['latitude'])
    else:
        return Point(data['x'], data['y'])


NOTIFICATION_FRIEND_REQUEST: str = 'friend-request'  # one has received request from someone
NOTIFICATION_FRIEND_RESPONSE: str = 'friend-response'  # one has responded to the request and the requestee will recieve the update
UNFRIEND: str = 'unfriend'
GENERAL_ACTIVITY: str = 'general-activity'
NEW_POST: str = 'new-post'
STARTED_FOLLOWING: str= 'started-following'
UNFOLLOW: str = 'unfollow'

TIME_FORMAT: str = "%H:%M:%S"
DATE_FORMAT: str = "%d-%m-%Y"
DATE_TIME_FORMAT: str = "%d-%m-%Y %H:%M:%S"


def get_ist():
    return datetime.now(timezone('Asia/Kolkata'))


def get_ist_time():
    return get_ist().time()


def get_ist_date():
    return get_ist().date()


def post_id_generator():
    return f'{token_urlsafe(16)}'
