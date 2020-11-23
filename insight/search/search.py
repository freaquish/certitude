from insight.models import *
from django.db.models import Q, QuerySet, F, CharField, Value
from django.db.models.functions import Concat
from insight.serializers import *
from fuzzywuzzy import fuzz
from insight.database.postgres import Levenshtein

"""
 search atags : Post containing atags, Account, community, competition related with query
 search hastags
 search first_name, last_name
 search hobby
 search competition
 search community
"""

EXCLUSION = {
    'users': [
        'account_id',
        '',
    ]
}


class SearchEngine:
    def __init__(self, **kwargs):
        if 'query' in kwargs:
            self.query = kwargs['query']
        if 'user' in kwargs:
            self.user: Account = kwargs['user']
        else:
            self.user = None
        if 'f_data' in kwargs:
            # For tag follow_up
            self.f_data: str = kwargs['f_data']
        else:
            self.f_data = None
        hobbies: QuerySet = Hobby.objects.all()
        self.hobby_dict = {hobby.code_name: hobby.name for hobby in hobbies.iterator()}

    def search_account_query(self, contains= False):
        if ' ' in self.query:
            query = None
            for q in self.query.split(' '):
                ques = Q(Q(username__istartswith=q) | Q(first_name__istartswith=q) |
                                      Q(last_name__istartswith=q)) if not contains else Q(Q(username__icontains=q) | Q(first_name__icontains=q) |
                                      Q(last_name__icontains=q))
                if '#' in q:
                    continue
                elif query:
                    q = q.replace('@', '')
                    query = query | ques
                else:
                    q = q.replace('@', '')
                    query = ques
            return query

        return Q(Q(username__icontains=self.query.replace('@', '')) | Q(
            first_name__icontains=self.query.replace('@', '')) | Q(
            last_name__icontains=self.query.replace('@', '')))

    def exclusion_user_query(self):
        exclusion_query = Q(username=self.user.username) if self.user else None
        for exclusive in EXCLUSION['users']:
            if not exclusion_query:
                exclusion_query = Q(username=exclusive)
            else:
                exclusion_query = exclusion_query | Q(username=exclusive)
        return exclusion_query

    def search_tag_query(self):
        if ' ' in self.query:
            query = None
            for q in self.query.split(' '):
                if '@' in q:
                    continue
                elif query:
                    q = q.replace('#', '')
                    query = query | Q(tag__istartswith=q)
                else:
                    q = q.replace('#', '')
                    query = Q(tag__istartswith=q)
            return query
        return Q(tag__istartswith=self.query)

    def search_hobby_query(self):
        if ' ' in self.query:
            query = None
            for q in self.query.split(' '):
                if '#' in q or '@' in q:
                    continue
                elif query:
                    query = query | Q(name__istartswith=q)
                else:
                    query = Q(name__istartswith=q)
            return query
        return Q(name__istartswith=self.query)

    @staticmethod
    def tag_avatar(tag: str):
        first = tag[1].upper()
        last = tag[-1].upper()
        for index in range(1, len(tag)):
            if tag[index].isupper() and tag[index] != first:
                last = tag[index].upper()
                break
        return first + last

    def user_in_association(self, account: Account):
        # check if user in friend or followed by the user searching
        if self.user:
            following = 0
            friend = 0
            if self.user.following and account.account_id in self.user.following:
                following = 1
            return following, friend
        return 0, 0

    def serialise_tag(self, tag: Tags):
        return {
            "tag": tag.tag,
            "avatar": self.tag_avatar(tag.tag),
            "type": "tag"
        }

    def serialise_account(self, account: Account):

        associated = self.user_in_association(account)
        hobby = self.hobby_dict[account.primary_hobby] if len(account.primary_hobby) > 0 else account.primary_hobby
        return {
            "account_id": account.account_id,
            "name": f'{account.first_name} {account.last_name}',
            "username": account.username,
            "hobby": hobby,
            "following": associated[0],
            "avatar": account.avatar,
            "type": "account",
        }

    @staticmethod
    def serialise_hobby(hobby: Hobby):
        return {
            "code_name": hobby.code_name,
            "name": hobby.name,
            "type": "hobby"
        }

    def search_tags(self):
        tags: QuerySet = Tags.objects.filter(self.search_tag_query()).annotate(tag_dist=Levenshtein(F('tag'), self.query))\
            .order_by('tag_dist')
        return [self.serialise_tag(tag) for tag in tags.iterator()]

    def search_users(self):
        accounts: QuerySet = Account.objects.filter(self.search_account_query()).exclude(self.exclusion_user_query())

        if accounts.exists():
            accounts: QuerySet = Account.objects.filter(self.search_account_query(contains=True)) \
                .exclude(self.exclusion_user_query()).annotate(u_dist=Levenshtein(F('username'), self.query),
                                                               name=Concat(F('first_name'), Value(' '), F('last_name'),
                                                                           output_field=CharField()),
                                                               name_dist=Levenshtein(F('name'), self.query)
                                                               ).order_by('name_dist', 'u_dist')

        return [self.serialise_account(user) for user in accounts.iterator()]

    def search_hobby(self):
        hobbies: QuerySet = Hobby.objects.filter(self.search_hobby_query()).annotate(dist=Levenshtein(F('name'), self.query)).order_by('dist')
        return [self.serialise_hobby(hobby) for hobby in hobbies.iterator()]

    def search(self):
        return {
            "tags": self.search_tags()[:6],
            "users": self.search_users(),
            "hobbies": self.search_hobby()[:6]
        }

    def hastag_follow_up(self):
        posts: QuerySet = Post.objects.filter(Q(hash_tags__tag=self.f_data)).order_by('-created_at')
        serializer = PostSerializer(posts, user=self.user)
        return {'posts': serializer.render(), 'len': len(posts)}

    def hobby_follow_up(self):
        posts: QuerySet = Post.objects.filter(hobby__code_name=self.f_data).order_by('-created_at')
        serializer = PostSerializer(posts, user=self.user)
        return {'posts': serializer.render(), 'len': len(posts)}
