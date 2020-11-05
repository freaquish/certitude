from insight.models import *
from insight.utils import get_ist, json_to_coord, post_id_generator
from django.db.models import Q, QuerySet
from insight.workers.interface import PostCreationInterface


class PostCreationManager(PostCreationInterface):

    def render_data(self) -> dict:
        hobbies: QuerySet = Hobby.objects.filter(code_name=self.map('hobby'))
        if not hobbies:
            return None
        data: dict = self.kwargs.copy()
        if 'coords' in self.kwargs:
            self.user.insert_coords(json_to_coord(self.map('coords')))
            self.user.save()
            data['coords'] = json_to_coord(self.map('coords'))
        data['created_at'] = get_ist()
        data['post_id'] = post_id_generator()
        data['account'] = self.user
        data['hobby'] = hobbies.first()
        data['is_global'] = True if self.map('is_global') == 1 else False
        data['action_count'] = {'love': 0, 'view': 0, 'share': 0, 'comment': 0, 'up_vote': 0, 'save': 0, 'down_vote': 0}
        return data

    def create_post(self):
        data: dict = self.render_data()
        if data is None:
            return data
        post: Post = Post.create_new(**data)
        self.after_creation()






