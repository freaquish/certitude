from django.contrib.gis.geos.point import Point
from datetime import datetime, date, time, timedelta
from secrets import token_urlsafe
from pytz import timezone
import pickle


def distance(coorda: Point, coordb: Point):
    return coorda.distance(coordb) * 100


def json_to_coord(data: dict):
    if 'long' in data:
        return Point(data['lat'], data['long'])
    elif 'longitude' in data:
        return Point(data['longitude'], data['latitude'])
    else:
        return Point(data['x'], data['y'])


# one has received request from someone
NOTIFICATION_FRIEND_REQUEST: str = 'friend-request'
# one has responded to the request and the requestee will recieve the update
NOTIFICATION_FRIEND_RESPONSE: str = 'friend-response'
UNFRIEND: str = 'unfriend'
GENERAL_ACTIVITY: str = 'general-activity'
NEW_POST: str = 'new-post'
STARTED_FOLLOWING: str = 'started-following'
UNFOLLOW: str = 'unfollow'

TIME_FORMAT: str = "%H:%M:%S"
DATE_FORMAT: str = "%d-%m-%Y"
DATE_TIME_FORMAT: str = "%d-%m-%Y %H:%M:%S"


def get_time_delta(ref, days=0, seconds=0):
    return ref - timedelta(days=days, seconds=seconds)


def get_ist():
    return datetime.now(timezone('Asia/Kolkata'))


def get_ist_time():
    return get_ist().time()


def get_ist_date():
    return get_ist().date()


def post_id_generator():
    return f'{token_urlsafe(16)}'


def next_sunday(today: datetime):
    return today + timedelta(days=6 - today.weekday())


def last_monday(today: datetime):
    return today - timedelta(days=today.weekday())


def store_data(name: str, data):
    with open(name, 'wb') as f:
        pickle.dump(data, f)


def restore_data(name: str):
    with open(name, 'rb') as f:
        return pickle.load(f)
