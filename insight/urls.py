from django.urls import path, include
from .views import *

urlpatterns = [
    path('auth/login', LoginView.as_view()),
    path('auth/username_check', username_available),
    path('auth/account_check', account_available),
    path('auth/change_password', ChangePassword.as_view()),
    path('auth/reset_password', ResetPassword.as_view()),
    path('auth/register', RegistrationView.as_view()),
    path('create_hobby', CreateHobby.as_view()),
    path('fetch_hobby', RetrieveHobby.as_view()),
    path('fetch_hobby/particular', FetchParticularHobby.as_view()),
    path('post/create', CreatePost.as_view()),
    path('post/micro_action', GeneralMicroActionView.as_view()),
    path('post/<str:pk>', OnePostView.as_view()),
    path('post/comments/<str:pid>', FetchComment.as_view()),
    path('feed', PaginatedFeedView.as_view()),
    path('profile/third/<str:username>', ThirdPartyProfileView.as_view()),
    path('profile/post/<str:username>', ProfilePosts.as_view()),
    path('profile', ProfileView.as_view()),
    path('profile/associate', ManageAssociation.as_view()),
    path('test/feed', PaginatedFeedView.as_view()),
    path('association/', include('insight.association.urls')),
    path('notification/', include('insight.notifications.urls')),
    path('search/', include('insight.search.urls')),
    path('leaderboard/', include('insight.leaderboard.urls')),
    path('community/', include('insight.community.urls')),
]
