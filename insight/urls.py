from django.urls import path
from .views import *

urlpatterns = [
    path('auth/login', LoginView.as_view()),
    path('auth/username_check', username_available),
    path('auth/account_check', account_available),
    path('auth/register', RegistrationView.as_view()),
    path('auth/reset_password', ResetPassword.as_view()),
    path('create_hobby', CreateHobby.as_view()),
    path('fetch_hobby', RetrieveHobby.as_view()),
    path('fetch_hobby/particular', FetchParticularHobby.as_view()),
    path('post/create', CreatePost.as_view()),
    path('post/micro_action', GeneralMicroActionView.as_view()),
    path('relation', MicroNotificationActions.as_view()),
    path('search', SearchView.as_view()),
    path('explore', ExploreView.as_view()),
    path('post/<str:pk>', OnePostView.as_view()),
    path('one_view/<str:iden>', OneLinkView.as_view()),
    path('feed', FeedView.as_view()),
    path('profile/third/<str:username>', ThirdPartyProfileView.as_view()),
    path('profile', ProfileView.as_view()),
    path('profile/associate',ManageAssociation.as_view()),
    path('post_comment', PostCommentView.as_view())
]
