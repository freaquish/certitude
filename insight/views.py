import json

from django.db.models import QuerySet
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, permission_classes
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from insight.actions.feed import Feed
from insight.actions.post_actions import authenticated_association
from rest_framework.authtoken.models import Token
from insight.actions.main import PostActions
from insight.actions.trends import Trends
from insight.workers.post_creation_manager import PostCreationManager
from insight.paginator import FeedPaginator
from insight.serializers import *


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
        token.delete()
        token: Token = Token.objects.create(user=account)
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
    account_id = request.GET['aid']
    accounts = Account.objects.filter(account_id=account_id)
    if not accounts:
        return Response({'available': 1}, status=status.HTTP_200_OK)
    else:
        data = {'available': 0}
        if 'rsp' in request.GET:
            account = accounts.first()
            token = Token.objects.get(user=account)
            data['token'] = token.key + f'{account_id[2]}{account_id[6]}'
            return Response(data, status=status.HTTP_200_OK)
        return Response(data, status=status.HTTP_200_OK)


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


class ResetPassword(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data = json.loads(request.body)
        if 'token' not in data or 'password' not in data:
            return Response({}, status=status.HTTP_403_FORBIDDEN)
        token_key = data['token']
        token_key = token_key[:len(token_key)-2]
        tokens: QuerySet = Token.objects.filter(key=token_key)
        if not tokens:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        token: Token = tokens.first()
        user: Account = token.user
        token.delete()
        user.set_password(data['password'])
        user.save()
        token: Token = Token.objects.create(user=user)
        return Response({}, status=status.HTTP_202_ACCEPTED)


class CreateHobby(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user: Account = request.user
        data: dict = json.loads(request.body)
        hobbies = []
        for hobby in data:
            hobbies.append(hobby)
        Hobby.objects.bulk_create(hobbies)
        hobbies_list = HobbySerializer(Hobby.objects.all(), many=True)
        return Response({"hobbies_list": hobbies_list.data}, status=status.HTTP_201_CREATED)


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

    def post(self, request):
        data: dict = json.loads(request.body)
        account: Account = request.user
        if account:
            if len(data['assets']) == 0:
                return Response({"msg": "successful"}, status=status.HTTP_201_CREATED)
            post_creation_manager: PostCreationManager = PostCreationManager(account, **data)
            post_creation_manager.create_post()
            return Response({"msg": "successful"}, status=status.HTTP_201_CREATED)
        return Response({}, status=status.HTTP_403_FORBIDDEN)


class GeneralMicroActionView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        user: Account = request.user
        posts: QuerySet = Post.objects.filter(post_id=request.GET['pid'])
        if not posts:
            return Response({}, status=status.HTTP_400_BAD_REQUEST)
        post_actions: PostActions = PostActions(user, posts.first())
        post_actions.micro_action(
            request.GET['action'])
        return Response({}, status=status.HTTP_200_OK)

    def post(self, request):
        print(request.body)
        data = json.loads(request.body)
        user: Account = request.user
        posts: QuerySet = Post.objects.filter(post_id=data['pid'])
        if not posts:
            return Response({}, status=status.HTTP_400_BAD_REQUEST)

        post_action:PostActions = PostActions(user, posts.first())
        post_action.micro_action(data['action'], val=data['comment'])
        comments = UserPostComment.objects.filter(post_id=data['pid'])
        serialized = CommentSerializer(comments).render()
        return Response({'comments': serialized}, status=status.HTTP_200_OK)


class ChangePassword(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user: Account = request.user
        data = json.loads(request.body)
        if user.check_password(data['old_password']):
            print(data)
            user.set_password(data['new_password'])
            user.save()
            token: Token = Token.objects.get(user=user)
            token.delete()
            token: Token = Token.objects.create(user=user)
            return Response({"token": token.key}, status=status.HTTP_202_ACCEPTED)
        return Response({}, status=status.HTTP_403_FORBIDDEN)


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
        serialized = PostSerializer([post], user).render_with_action(actions)[0]
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
        return Response({"comments": serialized.render()}, status=status.HTTP_200_OK)


class ThirdPartyProfileView(APIView):
    permission_classes = [AllowAny]

    user = None
    valid_user = False

    def get(self, request, username: str):
        self.user = request.user
        self.valid_user = True if self.user else False
        accounts: QuerySet = Account.objects.filter(username=username)
        if accounts:
            account: Account = accounts.first()
            serialized = ProfileSerializer(account).data
            following = 0
            if self.valid_user:
                following = 1 if account.account_id in self.user.following else 0
            hobby_query = None
            for hobby in account.hobby_map.keys():
                if hobby_query:
                    hobby_query = hobby_query | Q(code_name=hobby)
                else:
                    hobby_query = Q(code_name=hobby)
            hobbies = []
            if hobby_query:
                hobbies: QuerySet = Hobby.objects.filter(hobby_query)
            serialize_hobby = [hobby.name for hobby in hobbies]
            serialized['following'] = following
            serialized['hobbies'] = serialize_hobby
            return Response({"data":serialized, "self": 1 if self.user == account else 0}, status=status.HTTP_200_OK)
        return Response({}, status=status.HTTP_404_NOT_FOUND)


class ProfilePosts(APIView):
    permission_classes = [AllowAny]

    def get(self, request, username):
        posts: QuerySet = Post.objects.filter(account__username=username)
        if not posts:
            return Response({"posts": []}, status=status.HTTP_200_OK)
        serialized = [{"post_id": post.post_id, "hobby": post.hobby.code_name, "assets": post.assets} for post in posts]
        return Response({"posts": serialized}, status=status.HTTP_200_OK)


class ProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user: Account = request.user
        if not user:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        hobby_query = None
        for hobby in user.hobby_map.keys():
            if hobby_query:
                hobby_query = hobby_query | Q(code_name=hobby)
            else:
                hobby_query = Q(code_name=hobby)
        hobbies = []
        if hobby_query:
            hobbies: QuerySet = Hobby.objects.filter(hobby_query)
        serialize_hobby = [hobby.name for hobby in hobbies]
        serialized_account = ProfileSerializer(user).data
        serialized_account['hobbies'] = serialize_hobby
        return Response(serialized_account, status=status.HTTP_200_OK)

    def post(self, request):
        user: Account = request.user
        if not user:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        data = json.loads(request.body)
        if 'coords' in data:
            coords = data['coords']
            del data['coords']
            user.insert_coords(json_to_coord(coords))
        try:
            user.__dict__.update(**data)
            user.save()
        except Exception as e:
            return Response({}, status=status.HTTP_400_BAD_REQUEST)
        hobby_query = None
        for hobby in user.hobby_map.keys():
            if hobby_query:
                hobby_query = hobby_query | Q(code_name=hobby)
            else:
                hobby_query = Q(code_name=hobby)
        hobbies = []
        if hobby_query:
            hobbies: QuerySet = Hobby.objects.filter(hobby_query)
        serialize_hobby = [hobby.name for hobby in hobbies]
        serialized_account = ProfileSerializer(user).data
        serialized_account['hobbies'] = serialize_hobby
        return Response(serialized_account, status=status.HTTP_202_ACCEPTED)


class PaginatedFeedView(GenericAPIView):
    permission_classes = [AllowAny]
    trends = Trends()
    queryset = None
    serializer_class = PostSerializer
    pagination_class = FeedPaginator

    def get(self, request):
        user, valid = request.user, True
        if valid:
            trends = Trends(user)
            self.queryset, actions = trends.get_posts(trends.extract_queryset(trends.extract_trending_in_hobby_user()))
            # serialized_actions = ActionStoreSerializer(actions).data()
        else:
            self.queryset = self.trends.extract_queryset()
        length_queryset = len(self.queryset)
        page = self.paginate_queryset(self.queryset)
        if page is not None:
            serialized = PostSerializer(page, user if valid else None)
            if valid:
                result = self.get_paginated_response(
                    serialized.render_with_action(actions))
            else:
                result = self.get_paginated_response(serialized.render())
            data = result.data
        else:
            serialized = PostSerializer(self.queryset, user if valid else None)
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
