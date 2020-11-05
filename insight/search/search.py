from insight.models import *
from django.db.models import Q, QuerySet, F
from insight.serializers import *
from fuzzywuzzy import fuzz

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
        self.hobby = QuerySet()

    @staticmethod
    def tag_avatar(tag: str):
        first = tag[1].upper()
        last = tag[-1].upper()
        for index in range(1, len(tag)):
            if tag[index].isupper() and tag[index] != first:
                last = tag[index].upper()
                break
        return first + last

    def serialise_tag(self, tag: Tags):
        return {
            "tag": tag.tag,
            "avatar": self.tag_avatar(tag.tag)
        }

    def user_in_association(self, account: Account):
        # check if user in friend or followed by the user searching
        if self.user:
            following = 0
            friend = 0
            if self.user.following and account.account_id in self.user.following:
                following = 1
            if self.user.friend and account.account_id in self.user.friend:
                friend = 1
            return following, friend
        return 0, 0

    def serialise_account(self, account: Account):
        hobbies: QuerySet = self.hobby.filter(code_name=account.primary_hobby)
        hobby = None
        if hobbies:
            hobby: Hobby = hobbies.first()
        associated = self.user_in_association(account)
        return {
            "account_id": account.account_id,
            "name": f'{account.first_name} {account.last_name}',
            "username": account.username,
            "hobby": hobby.name if hobby else '',
            "following": associated[0],
            "friend": associated[1],
            "avatar": account.avatar
        }

    def search_tags(self):
        self.hobby = Hobby.objects.all()
        tags = Tags.objects.filter(self.search_tag_query()).values_list('tag', flat=True)
        return [self.serialise_tag(tag) for tag in sorted(tags, key=lambda tag_str: fuzz.ratio(self.query, tag_str),
                                                          reverse=True)]

    def search_account_query(self):
        if ' ' in self.query:
            query = None
            for q in self.query.split(' '):
                if '#' in q:
                    continue
                elif query:
                    q = q.replace('@', '')
                    query = query | Q(Q(username__icontains=q) | Q(first_name__icontains=q) | Q(last_name__icontains=q))
                else:
                    q = q.replace('@', '')
                    query = Q(Q(username__icontains=q) | Q(first_name__icontains=q) | Q(last_name__icontains=q))
            return query
       
        return Q(Q(username__icontains=self.query.replace('@', '')) | Q(first_name__icontains=self.query.replace('@', '')) | Q(
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
                    query = query | Q(tag__icontains=q)
                else:
                    q = q.replace('#', '')
                    query = Q(tag__icontains=q)
            return query
        return Q(tag__icontains=self.query)

    def search_hobby_query(self):
        if ' ' in self.query:
            query = None
            for q in self.query.split(' '):
                if '#' in q or '@' in q:
                    continue
                elif query:
                    query = query | Q(name__icontains=q)
                else:
                    query = Q(name__icontains=q)
            return query
        return Q(name__icontains=self.query)

    def search_users(self):
        accounts = Account.objects.filter(self.search_account_query()).exclude(self.exclusion_user_query())\
            .values_list('first_name', 'last_name', 'username')
        return [self.serialise_account(user) for user in sorted(accounts, key=lambda wo: [fuzz.ratio(self.query, param) for param in wo], reverse=True)]

    @staticmethod
    def serialise_hobby(hobby: Hobby):
        return {
            "code_name": hobby.code_name,
            "name": hobby.name
        }

    def search_hobby(self):
        hobbies = Hobby.objects.filter(self.search_hobby_query()).values_list('name', flat=True)
        return [self.serialise_hobby(hobby) for hobby in sorted(hobbies, key=lambda hobby: fuzz.ratio(self.query, hobby), reverse=True)]

    def search(self):
        return {
            "tags": self.search_tags()[:6],
            "users": self.search_users(),
            "hobbies": self.search_hobby()[:6]
        }

    def hastag_follow_up(self):
        posts: QuerySet = Post.objects.filter(Q(hastags__contains=[self.f_data])).order_by('-created_at')
        serializer = PostSerializer(posts, self.user)
        return {'posts': serializer.render(), 'len': len(posts)}

    def hobby_follow_up(self):
        posts: QuerySet = Post.objects.filter(hobby__code_name=self.f_data).order_by('-created_at')
        serializer = PostSerializer(posts, self.user)
        return {'posts': serializer.render(), 'len': len(posts)}
