from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token

from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from insight.actions.notification_actions import *

from insight.actions.post_actions import authenticated_mirco_actions, general_micro_actions

from insight.models import *
from insight.actions.search import Search
from insight.actions.explore import Explorer
from insight.actions.feed import Feed
from insight.utils import *
from insight.serializers import *
import json


# Create your views here..
class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data: dict = json.loads(request.body)
        account: QuerySet = Account.objects.filter(
            account_id=data['account_id'])
        if not account:
            return Response({'error': 'No Account Found'}, status=status.HTTP_404_NOT_FOUND)
        account: Account = account.first()
        if not account.check_password(data['password']):
            return Response({"error": "Invalid Credentials"}, status=status.HTTP_401_UNAUTHORIZED)
        token: Token = Token.objects.get(user=account)
        if 'coords' in data.keys():
            account.objects.insert_coords(json_to_coord(data['coords']))
        return Response({'token': token.key, 'first_name': account.first_name, 'avatar': account.avatar},
                        status=status.HTTP_202_ACCEPTED)


@api_view(['GET'])
@permission_classes([AllowAny])
def username_available(request):
    result = False
    username = request.GET['username']
    if len(username) >= 6 and not ('#' in username and '$' in username and '@' in username):
        accounts = Account.objects.filter(username=username)
        if not accounts:
            return Response({'available': 1}, status=status.HTTP_200_OK)
        else:
            return Response({'available': 0}, status=status.HTTP_200_OK)
    else:
        return Response({'available': 0}, status=status.HTTP_200_OK)


class RegistrationView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data: dict = json.loads(request.body)
        try:
            assert data['first_name'] and data['last_name'] and data['account_id'] and data['password'], KeyError()
            id_type: str = 'PHONE'
            accounts = Account.objects.filter(Q(account_id=data['account_id']))
            if accounts:
                return Response({}, status=status.HTTP_403_FORBIDDEN)
            password = data['password']
            del data['password']
            account = Account.objects.create(**data)
            account.set_password(password)
            account.is_active = True
            if 'coords' in data.keys():
                account.insert_coords(json_to_coord(data['coords']))
            account.save()
            token = Token.objects.create(user=account)
            return Response({'token': token.key, 'first_name': account.first_name, 'avatar': account.avatar},
                            status=status.HTTP_201_CREATED)
        except KeyError as key_error:
            print(key_error)
            return Response({"error": "Incomplete data"}, status=status.HTTP_406_NOT_ACCEPTABLE)


class ResetPassword(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data = json.loads(request.body)
        account = Account.objects.filter(account_id=data['account_id'])
        if not account:
            return Response({"error": "No Associated account Found"}, status=status.HTTP_404_NOT_FOUND)
        account = account.first()
        account.set_password(data['password'])
        if 'coords' in data.keys():
            account.objects.insert_coords(json_to_coord(data['coords']))
        account.save()
        token = Token.objects.get(user=account)
        return Response({'token': token.key, 'first_name': account.first_name, 'avatar': account.avatar},
                        status=status.HTTP_202_ACCEPTED)


class SharedPost(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        data: dict = request.GET
        posts = Post.objects.filter(post_id=data['post'])
        if not posts:
            return Response({"error": "No Post Found"}, status=status.HTTP_404_NOT_FOUND)
        post = posts.first()
        serialized = PostSerializer(post).serialize()
        return Response(serialized, status=status.HTTP_200_OK)


class CreateHobby(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user: Account = Token.objects.get(key=request.META.get('HTTP_AUTHORIZATION')).user
        if not (user.is_staff and user.is_superuser):
            return Response({}, status=status.HTTP_401_UNAUTHORIZED)
        data: dict = json.loads(request.body)
        hobby = Hobby.objects.get_or_create(code_name=data['code_name'])[0]
        hobby.name = data['name']
        if 'editors' in data.keys():
            hobby.editors = list(set(hobby.editors + data['editors'].split(','))) if hobby.editors else data[
                'editors'].split(',')
        if 'limits' in data.keys():
            hobby.limits = data['limits']
        if 'weight' in data.keys():
            hobby.weight = float(data['weight'])
        hobby.save()
        return Response({"code_name": hobby.code_name,
                         "name": hobby.name,
                         "editors": hobby.editors,
                         "limits": hobby.limits,
                         "weight": hobby.weight}, status=status.HTTP_201_CREATED)


class RetrieveHobby(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        data: dict = request.GET
        hobbies = Hobby.objects.all()
        serialized_data = HobbySerializer(hobbies, many=True)
        return Response({'hobbies': serialized_data.data}, status=status.HTTP_200_OK)


class FetchParticularHobby(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        data: dict = request.GET
        hobbies = Hobby.objects.filter(code_name=data['q'])
        if hobbies:
            hobby = hobbies.first()
            serialized = HobbySerializer(hobby)
            return Response({'hobby': serialized.data}, status=status.HTTP_200_OK)
        else:
            return Response({"error": "No Hobby found!"}, status=status.HTTP_404_NOT_FOUND)


class CreatePost(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def verify_token(self):
        if 'HTTP_AUTHORIZATION' in self.request.META:
            token_key = self.request.META.get('HTTP_AUTHORIZATION')
            token_key = "".join(token_key.split('Token ')
                                ) if 'Token' in token_key else token_key
            token = Token.objects.filter(key=token_key)
            self.feed = Feed(token.user)
            self.user: Account = token.user
            self.valid_user = True
        else:
            self.feed = Feed()
            self.valid_user = False

    def post(self, request):
        data: dict = json.loads(request.body)
        try:
            self.verify_token()
            if not self.valid_user:
                return Response({}, status=status.HTTP_403_FORBIDDEN)
            account = self.user
            is_coord_present = False
            if 'coords' in data:
                is_coord_present = True
                account.objects.insert_coords(json_to_coord(data['coords']))
                account.save()
            hobby = Hobby.objects.get(code_name=data['hobby'])
            post = Post.objects.create(
                post_id=post_ig_generator(),
                username=account.username,
                account_id=account.account_id,
                avatar=account.avatar,
                hobby=data['hobby'],
                hobby_name=data['hobby_name'],
                hobby_weight=hobby.weight,
                assets=data['assets'],
                caption=data['caption'],
                editor=data['editor'],
                hastags=data['hastags'],
                atags=data['atags'],
                coords=json_to_coord(
                    data['coords']) if is_coord_present else account.current_coord,
                action_count={'love': 0, 'view': 0,
                              'share': 0, 'save': 0, 'comment': 0},
                created_at=get_ist(),
                rank=0,
                score=0.0,
            )
            tag_query = None
            all_tags = post.hastags + post.atags
            for tag in all_tags:
                if not tag_query:
                    tag_query = Q(tag=tag)
                else:
                    tag_query = tag_query | Q(tag=tag)

            tag_query_length = len(tag_query)
            tags_present = Tags.objects.filter(tag_query)
            tags_present_length = len(tags_present)
            if tag_query_length - tags_present_length > 0:
                present_tag_names = [tag.tag for tag in tags_present]
                not_present_tags = filter(
                    lambda tag: tag not in present_tag_names, all_tags)
                tags = Tags.objects.bulk_create(
                    [Tags(tag=tag_name, created_at=get_ist(), first_used=post.post_id) for tag_name in
                     not_present_tags])
            # Notify all followers and friends that new post has arrived
            notify = notify_about_new_post.delay(
                post.post_id, post.hobby_name, post.account_id)
            return Response({"msg": "successful"}, status=status.HTTP_201_CREATED)
        except Exception as exception:
            return Response({"msg": "Post Creation Failed. Try again later"}, status=status.HTTP_400_BAD_REQUEST)


class GeneralMicroActionView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        token = None
        if 'HTTP_AUTHORIZATION' in request.META:
            token = request.META.get('HTTP_AUTHORIZATION')
            authenticated_mirco_actions.delay(
                {"action": request.GET['action'], "pid": request.GET['pid']}, token)
        else:
            general_micro_actions.delay(request.GET)
        return Response({}, status=status.HTTP_200_OK)

    def post(self, request):
        data = json.loads(request.body)
        token = None
        if 'HTTP_AUTHORIZATION' in request.META:
            token = request.META.get('HTTP_AUTHORIZATION')
            authenticated_mirco_actions.delay(
                {"action": data['action'], "pid": data['pid'], 'comment': data['comment']}, token, req_type='POST')
        return Response({}, status=status.HTTP_200_OK)


class MicroNotificationActions(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # ? rid={requested_id: person to be requested}, uid={requesting_id: person who is requesting}
        data: dict = request.GET
        action = data['action']
        noti_actions = NotificationActions(
            requested_id=data['rid'], requesting_id=data['uid'])
        if action == NOTIFICATION_FRIEND_REQUEST:
            noti_actions.send_friend_request()
        elif action == NOTIFICATION_FRIEND_RESPONSE:
            # if flag ==1 accepted , 0 declined
            if data['flag'] == 1:
                noti_actions.accept_friend_request()
            else:
                noti_actions.decline_friend_request()
        elif action == UNFRIEND:
            noti_actions.unfriend_user()
        elif action == STARTED_FOLLOWING:
            noti_actions.follow_user()
        elif action == UNFOLLOW:
            noti_actions.unfollow_user()
        if data['rr'] == 1:  # return_required={int}
            account = Account.objects.get(account_id=data['rid'])
            serialized = ProfileSerializer(account)
            return Response(serialized.data, status=status.HTTP_202_ACCEPTED)
        else:
            return Response({}, status=status.HTTP_202_ACCEPTED)


class SearchView(APIView):
    permission_classes = [AllowAny]

    def get_queryset(self):
        data = self.request.GET
        token = None
        if 'HTTP_AUTHORIZATION' in self.request.META:
            token_key = self.request.META.get('HTTP_AUTHORIZATION')
            token_key = "".join(token_key.split('Token ')
                                ) if 'Token' in token_key else token_key
            token = Token.objects.filter(key=token_key)

        if token:
            self.account = token.first().user
            self.search = Search(account=self.account, query=data['q'])
            return self.search.search_tags(), self.search.search_hobby(), self.search.search_accounts()
        else:
            self.search = Search(query=data['q'])
            return self.search.search_tags(), self.search.search_hobby(), self.search.search_accounts()

    def get(self, request):
        self.request = request
        tags, hobbies, accounts = self.get_queryset()
        serialized_accounts = [{'account_id': account.account_id, 'username': account.username,
                                'first_name': account.first_name, 'last_name': account.last_name,
                                'influnecer': 1 if account.influencer else 0, 'hobby': account.primary_hobby,
                                'avatar': account.avatar,
                                'following': 1 if self.account and self.account.account_id in account.following else 0,
                                'friend': 1 if self.account and self.account.account_id in account.friend else 0
                                } for account in accounts]
        serialized_tags = [tag.tag for tag in tags]
        serialized_hobby = [
            {'name': hobby.name, 'code_name': hobby.code_name} for hobby in hobbies]
        return Response({'tags': serialized_tags, 'hobbies': serialized_hobby, 'accounts': serialized_accounts},
                        status=status.HTTP_200_OK)


class ExploreView(APIView):
    permission_classes = [AllowAny]

    def verify_token(self):
        if 'HTTP_AUTHORIZATION' in self.request.META:
            token_key = self.request.META.get('HTTP_AUTHORIZATION')
            token_key = "".join(token_key.split('Token ')
                                ) if 'Token' in token_key else token_key
            token = Token.objects.filter(key=token_key)
            self.explorer = Explorer(token.user)
            self.valid_user = True
        else:
            self.explorer = Explorer()
            self.valid_user = False

    def get(self, request):
        self.request = request
        self.verify_token()
        if self.valid_user:
            data = self.request.GET
            if 'hobby' in data:
                posts = self.explorer.filter_hobby(data['hobby'])
                serialized_posts = [
                    self.explorer.serialize_post(post) for post in posts]
                return Response({"posts": serialized_posts}, status=status.HTTP_200_OK)
            else:
                serialized_posts = [self.explorer.serialize_post(
                    post) for post in self.explorer.explore_known()]
                return Response({"posts": serialized_posts}, status=status.HTTP_200_OK)
        else:
            serialized_posts = [self.explorer.serialize_post(
                post) for post in self.explorer.explore_anonymous()]
            return Response({"posts": serialized_posts}, status=status.HTTP_200_OK)


class OnePostView(APIView):
    permission_classes = [AllowAny]

    """
       mapped to url /post/<pk:post>
       will find the post and comment data and sent to user 
    """

    def get(self, request, pk):
        post = Post.objects.filter(post_id=pk)
        if post:
            post = post.first()
            comment = PostComment.objects.get(post_id=pk)
            serialized_post = {
                "post_id": post.post_id,
                "header": {
                    "username": post.username,
                    "avatar": post.avatar,
                    "account_id": post.account_id,
                    "hobby": post.hobby,
                    "hobby_name": post.hobby_name,
                    "rank": post.rank
                },
                "body": post.assets,
                "captions": post.caption,
                "footer": {
                    "actions": post.action_count,
                    "comments": comment.comments
                },
                "meta": {
                    "created": f'{((get_ist() - post.created_at).seconds / 3600)}h',
                    "score": post.score,
                    "editor": post.editor
                }
            }
            return Response(serialized_post, status=status.HTTP_200_OK)
        else:
            return Response({}, status=status.HTTP_404_NOT_FOUND)


class FeedView(APIView):
    permission_classes = [AllowAny]

    def verify_token(self):
        if 'HTTP_AUTHORIZATION' in self.request.META:
            token_key = self.request.META.get('HTTP_AUTHORIZATION')
            token_key = "".join(token_key.split('Token ')
                                ) if 'Token' in token_key else token_key
            token = Token.objects.get(key=token_key)
            self.feed = Feed(token.user)
            self.user: Account = token.user
            self.valid_user = True
        else:
            self.feed = Feed()
            self.valid_user = False

    def get(self, request):
        self.request = request
        self.verify_token()
        if self.valid_user:
            posts, actions = self.feed.extract_feed_known()
            serialized_actions = ActionStoreSerializer(actions).data()
            serialized = PostSerializer(
                posts).render_with_action(serialized_actions)
            return Response({'posts': serialized,
                             'meta': {'avatar': self.user.avatar, 'first_name': self.user.first_name},
                             'notification': 1 if self.user.new_notification else 0}, status=status.HTTP_200_OK)
        else:
            posts = self.feed.feed_anonymous()
            serialized = PostSerializer(posts).render()
            return Response({'posts': serialized}, status=status.HTTP_200_OK)


class OneLinkView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, iden: str):
        delim = ''
        d_type = ''
        query = None
        if 'h__' in iden:
            delim = iden.replace('h__', '', 1)
            d_type = 'hastag'
            query = Q(hastags__contains=[delim])
        elif 'a__' in iden:
            delim = iden.replace('a__', '', 1)
            d_type = 'atag'
            query = Q(atags__contains=[delim])
        elif 'ho__' in iden:
            delim = iden.replace('ho__', '', 1)
            d_type = 'hobby'
            query = Q(hobby=delim)
        posts = Post.objects.filter(query).order_by('score', '-created_at')
        serialized_posts = [{"post_id": post.id, "hobby": post.hobby,
                             "assets": post.assets, "editor": post.editor} for post in posts]
        return Response({'title': delim, 'type': d_type, 'posts': serialized_posts}, status=status.HTTP_200_OK)


class ThirdPartyProfileView(APIView):
    permission_classes = [AllowAny]

    def verify_token(self):
        if 'HTTP_AUTHORIZATION' in self.request.META:
            token_key = self.request.META.get('HTTP_AUTHORIZATION')
            if 'Token' in token_key:
                token_key = "".join(token_key.split('Token '))
            token = Token.objects.get(key=token_key)
            self.user: Account = token.user
            self.valid_user = True
        else:
            self.valid_user = False

    def get(self, request, username: str):
        self.request = request
        self.verify_token()
        accounts: QuerySet = Account.objects.filter(username=username)
        if accounts:
            account: Account = accounts.first()
            serialized = ProfileSerializer(account).data
            following = 0
            friends = 0 
            if self.valid_user:
                following = 1 if account.account_id in self.user.following else 0
                friends = 1 if account.account_id in self.user.friend else 0
            serialized['following'] = following 
            serialized['friend'] = friends 
            return Response(serialized, status=status.HTTP_200_OK)
        return Response({}, status=status.HTTP_404_NOT_FOUND)


class ProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    @staticmethod
    def verify_token(request):
        token_key: str = request.META.get('HTTP_AUTHORIZATION')
        token: str = "".join(token_key.split('Token ')
                             ) if 'Token' in token_key else token_key
        token_objs: QuerySet = Token.objects.filter(key=token)
        if not token_objs:
            return None
        token_obj: Token = token_objs.first()
        return token_obj.user

    def get(self, request):
        user = self.verify_token(request)
        if not user:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        posts = Post.objects.filter(account_id=user.account_id)
        serialized_posts = [{"post_id": post.id, "hobby": post.hobby,
                             "assets": post.assets, "editor": post.editor} for post in posts]
        serialized_account = ProfileSerializer(user).data
        serialized_account['posts'] = serialized_posts
        return Response(serialized_account, status=status.HTTP_200_OK)

    def post(self, request):
        user: Account = self.verify_token(request)
        if not user:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        data = json.loads(request.body)
        if 'coords' in data:
            coords = data['coords']
            del data['coords']
            user.__class__.objects.insert_coords(json_to_coord(coords))
        if 'places' in data:
            place_list = []
            for place in data['places']:
                place_list.append(Places(place_name=place[0], city=place[1]))
                user.places.append(f'{place[0]},{place[1]}')
            Places.objects.bulk_create(place_list)
            del data['places']
        try:
            print(data)
            user.__dict__.update(**data)  #using stone way because object.update isn't working
            user.save()
        except Exception as e:
            return Response({}, status=status.HTTP_400_BAD_REQUEST)

        posts = Post.objects.filter(account_id=user.account_id)
        serialized_posts = [{"post_id": post.id, "hobby": post.hobby, "assets": post.assets, "editor": post.editor} for
                            post in posts]
        serialized_account = ProfileSerializer(user).data
        serialized_account['posts'] = serialized_posts
        return Response(serialized_account, status=status.HTTP_202_ACCEPTED)
