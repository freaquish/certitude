from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.generics import GenericAPIView
from rest_framework.authtoken.models import Token

from insight.manager import analyzer

from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from django.db.models import QuerySet
from django.db.models import Q


from insight.actions.post_actions import authenticated_mirco_actions, general_micro_actions, authenticated_association, MicroActions
from insight.paginator import FeedPaginator
from insight.models import *
from insight.actions.feed import Feed
from insight.utils import *
from insight.serializers import *
import json


"""
  Identify using token provided in header and returns Account,valid_user
"""


def identify_token(request):
    if 'HTTP_AUTHORIZATION' in request.META:
        token_key = request.META.get('HTTP_AUTHORIZATION')
        token_key = "".join(token_key.split('Token ')
                            ) if 'Token' in token_key else token_key
        tokens = Token.objects.filter(key=token_key)
        if not tokens:
            return None, False
        token = tokens.first()
        return token.user, True


# Create your views here..
class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data: dict = json.loads(request.body)
        accounts: QuerySet = Account.objects.filter(
            account_id=data['account_id'])
        if not accounts:
            return Response({'error': 'No Account Found'}, status=status.HTTP_404_NOT_FOUND)
        account: Account = accounts.first()
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


@api_view(['GET'])
@permission_classes([AllowAny])
def account_available(request):
    result = False
    account_id = request.GET['aid']
    if len(account_id) >= 10:
        accounts = Account.objects.filter(account_id=account_id)
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
            data['username'] = data['username'].strip()
            data['account_id'] = data['account_id'].strip()
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


class CreateHobby(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        if not 'HTTP_AUTHORIZATION' in request.META:
            return Response({}, status=status.HTTP_403_FORBIDDEN)
        user: Account = Token.objects.get(
            key=request.META.get('HTTP_AUTHORIZATION')).user
        if not (user.is_staff and user.is_superuser):
            return Response({}, status=status.HTTP_401_UNAUTHORIZED)
        data: dict = json.loads(request.body)
        hobbies = []
        for hobby in data:
            hobbies.append(hobby)
        Hobby.objects.bulk_create(hobbies)
        hobbies_list = HobbySerializer(Hobby.objects.all(), many=True)
        return Response({"hobbies_list": hobbies.data}, status=status.HTTP_201_CREATED)


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
            if token:
                token = token.first()
                self.user: Account = token.user
                self.valid_user = True
            else:
                self.valid_user = False
        else:
            self.valid_user = False

    def post(self, request):
        data: dict = json.loads(request.body)
        if True:
            self.user: Account = request.user 
            self.valid_user = True if self.user else False
            if not self.valid_user:
                return Response({}, status=status.HTTP_403_FORBIDDEN)
            if len(data['assets']) == 0:
                return Response({"msg": "successful"}, status=status.HTTP_201_CREATED)
            account = self.user
            is_coord_present = False
            if 'coords' in data:
                is_coord_present = True
                account.objects.insert_coords(json_to_coord(data['coords']))
                account.save()
            hobby = Hobby.objects.get(code_name=data['hobby'])
            post_id = post_id_generator()
            if 'coords' in data:
                data['coords'] = json_to_coord(data['coords'])
            data['created_at'] = get_ist()
            data['action_count'] = {'love': 0, 'view': 0,
                                    'share': 0, 'save': 0, 'comment': 0}
            data['rank'] = 0
            data['score'] = 0.0
            data['account'] = account
            data['hobby'] = hobby
            data['post_id'] = post_id
            post = Post.objects.create(**data)
            analyze_post = analyzer.Analyzer(account)
            analyze_post.analyze_create_post(post)

            all_tags = post.hastags + post.atags
            if all_tags:
                tag_query = None
                for tag in all_tags:
                    if tag_query:
                        tag_query = tag_query | Q(tag=tag)
                    else:
                        tag_query = Q(tag=tag)
                
                tags_present_in_db = Tags.objects.filter(tag_query).values_list('tag',flat=True)
                if len(all_tags) != len(tags_present_in_db):
                    # find all tags which are not present in db



            # all_tags = post.hastags + post.atags
            # if all_tags:
            #     tag_query = None
            #     for tag in all_tags:
            #         if not tag_query:
            #             tag_query = Q(tag=tag)
            #         else:
            #             tag_query = tag_query | Q(tag=tag)

            #     tag_query_length = len(tag_query)
            #     tags_present = Tags.objects.filter(tag_query)
            #     tags_present_length = len(tags_present)
            #     if tag_query_length - tags_present_length > 0:
            #         present_tag_names = [tag.tag for tag in tags_present]
            #         not_present_tags = filter(
            #             lambda tag: tag not in present_tag_names, all_tags)
            #         tags = Tags.objects.bulk_create(
            #             [Tags(tag=tag_name, created_at=get_ist(), first_used=post.post_id) for tag_name in
            #              not_present_tags])

            # notify = notify_about_new_post.delay(
            #     post.post_id, post.hobby_name, post.account_id)
            # Future Scope
            return Response({"msg": "successful"}, status=status.HTTP_201_CREATED)
        else:
            return Response({"msg": "Post Creation Failed. Try again later"}, status=status.HTTP_400_BAD_REQUEST)


class GeneralMicroActionView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        token = None
        if 'HTTP_AUTHORIZATION' in request.META:
            token = request.META.get('HTTP_AUTHORIZATION')
            authenticated_mirco_actions(
                {"action": request.GET['action'], "pid": request.GET['pid']}, token)
        else:
            general_micro_actions.delay(request.GET)
        return Response({}, status=status.HTTP_200_OK)

    def post(self, request):
        print(request.body)
        data = json.loads(request.body)
        token = None
        if 'HTTP_AUTHORIZATION' in request.META:
            token = request.META.get('HTTP_AUTHORIZATION')
            authenticated_mirco_actions(
                {"action": data['action'], "pid": data['pid'], 'comment': data['comment']}, token, req_type='POST')
            if data['action'] == 'comment':
              comments = UserPostComment.objects.filter(post_id=data['pid'])
              serialized = CommentSerializer(comments).render()
              return Response({'comments': serialized}, status=status.HTTP_200_OK)
        return Response({}, status=status.HTTP_200_OK)


class ManageAssociation(APIView):
    permission_classes = [AllowAny]
    """
    Must not deprecate, currently used in PostBox
    """
    def get(self, request):
        if 'HTTP_AUTHORIZATION' in request.META:
            token = request.META.get('HTTP_AUTHORIZATION')
            if request.GET['action'] == 'follow' or request.GET['action'] == 'un_follow':
                authenticated_association.delay(
                    token, request.GET['fid'], follow=False if request.GET['action'] == 'un_follow' else True)
            return Response({}, status=status.HTTP_200_OK)
        else:
            return Response({}, status=status.HTTP_403_FORBIDDEN)


class OnePostView(APIView):
    permission_classes = [AllowAny]

    """
       mapped to url /post/<pk:post>
       will find the post and comment data and sent to user
    """
    def get(self, request, pk):
      user = request.user
      posts = Post.objects.filter(post_id=pk)
      if not posts:
        return Response({}, status=status.HTTP_404_NOT_FOUND)
      post = posts.first()
      actions = ActionStore.objects.filter(post_id=post.post_id)
      serialized = PostSerializer([post],user).render_with_action(actions)[0]
      comments = UserPostComment.objects.filter(post_id=post.post_id).order_by('created_at')
      serialized_comments = CommentSerializer(comments) 
      serialized['footer']['comments'] = serialized_comments.render() 
      return Response({'post': serialized}, status=status.HTTP_200_OK)


class FetchComment(APIView):
  authentication_classes = [TokenAuthentication]
  permission_classes = [IsAuthenticated]

  def get(self, request, pid: str):
    user = request.user 
    comments = UserPostComment.objects.filter(post_id=pid).order_by('created_at')
    serialized = CommentSerializer(comments)
    return Response({"comments":serialized.render()}, status=status.HTTP_200_OK)

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
            print(request.user.username)
            if self.user == account:
                return Response({"self": 1}, status=status.HTTP_200_OK)
            serialized = ProfileSerializer(account).data
            following = 0
            friends = 0
            if self.valid_user:
                following = 1 if account.account_id in self.user.following else 0
                friends = 1 if account.account_id in self.user.friend else 0
                if friends == 0:
                    notifications = Notification.objects.filter(Q(Q(Q(to=account) | Q(to=self.user)) & Q(Q(header=self.user.username) | Q(header=account.username))) & Q(type='REQU'))
                    sent_notifications: QuerySet = notifications.filter(Q(to=account) & Q(header=self.user.username))
                    received_notifications: QuerySet = notifications.filter(Q(to=self.user) & Q(header=account.username))
                    if sent_notifications:
                        serialized['isSentRequest'] = 1
                    if received_notifications:
                        serialized['isReceivedRequest'] = 1


            serialized['following'] = following
            serialized['friend'] = friends
            posts = Post.objects.filter(account__account_id=account.account_id)
            serialized_posts = [{"post_id": post.post_id, "hobby": post.hobby.code_name,
                                 "assets": post.assets, "editor": post.editor} for post in posts]
            serialized['posts'] = serialized_posts
            return Response(serialized, status=status.HTTP_200_OK)
        return Response({}, status=status.HTTP_404_NOT_FOUND)


class ProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    @staticmethod
    def verify_token(request):
        if not 'HTTP_AUTHORIZATION' in request.META:
            return None
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
        posts = Post.objects.filter(account__account_id=user.account_id)
        serialized_posts = [{"post_id": post.post_id, "hobby": post.hobby.code_name,
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
            user.insert_coords(json_to_coord(coords))
        if 'places' in data:
            place_list = []
            for place in data['places']:
                place_list.append(Places(place_name=place[0], city=place[1]))
                user.places.append(f'{place[0]},{place[1]}')
            Places.objects.bulk_create(place_list)
            del data['places']
        try:
            user.__dict__.update(**data)
            user.save()
        except Exception as e:
            return Response({}, status=status.HTTP_400_BAD_REQUEST)

        posts = Post.objects.filter(account_id=user.account_id)
        serialized_posts = [{"post_id": post.id, "hobby": post.hobby, "assets": post.assets, "editor": post.editor} for
                            post in posts]
        serialized_account = ProfileSerializer(user).data
        serialized_account['posts'] = serialized_posts
        return Response(serialized_account, status=status.HTTP_202_ACCEPTED)


class PaginatedFeedView(GenericAPIView):
    permission_classes = [AllowAny]
    feed = Feed()
    queryset = feed.feed_anonymous()
    serializer_class = PostSerializer
    pagination_class = FeedPaginator

    def get(self, request):
        user, valid = identify_token(request)
        if valid:
            feed = Feed(user)
            queryset, actions = feed.extract_feed_known()
            # serialized_actions = ActionStoreSerializer(actions).data()
        length_queryset = len(queryset)
        page = self.paginate_queryset(queryset)

        if page is not None:
            serialized = PostSerializer(page, user if valid else None)
            if valid:
                result = self.get_paginated_response(
                    serialized.render_with_action(actions))
            else:
                result = self.get_paginated_response(serialized.render())
            data = result.data
        else:
            serialized = PostSerializer(queryset, user if valid else None)
            if valid:
                data = serialized.render_with_action(actions)
            else:
                data = serialized.render()
        # print(len(data))
        if valid:
            response = {'meta': {'avatar': user.avatar, 'first_name': user.first_name}, "len": length_queryset,
                        'notification': 1 if user.new_notification else 0}
            response.update(data)
            return Response(response)
        data.update({"len": length_queryset})
        return Response(data, status=status.HTTP_200_OK)
