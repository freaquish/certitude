from django.db import models
from django.contrib.gis.db import models as gis_models
from django.contrib.postgres.fields import ArrayField, JSONField
from django.contrib.gis.geos.point import Point
from django.contrib.auth.base_user import AbstractBaseUser
from django.utils import timezone
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from rest_framework.authtoken.models import Token


# Create your models here.


class AccountManager(BaseUserManager):
    use_in_migrations: bool = True

    @staticmethod
    def sanitize_account_id(account_id: str, country_code: str):
        length: int = len(country_code)
        pre_sanitized: str = account_id.replace(" ", "")
        if '+' in pre_sanitized:
            return pre_sanitized[length:]
        else:
            return pre_sanitized

    def _create_account(self, account_id: str, id_type: str, joined_at: str, password: str, is_staff: bool,
                        is_superuser: bool, country_code: str = '+91'):
        assert (account_id and id_type and joined_at and password), 'Incomplete Data'
        account: Account = self.model.object.create(
            account_id=self.sanitize_account_id(account_id, country_code) if id_type == 'PHONE' else account_id,
            id_type=id_type, joined_at=joined_at, is_staff=is_staff, is_superuser=is_superuser
        )
        account.set_password(password)
        account.save()
        token: Token = Token.objects.create(user=account)
        return account

    def create_user_account(self, account_id: str, id_type: str, joined_at: str, password: str,
                            country_code: str = '+91'):
        self._create_account(account_id, id_type, joined_at, password, False, False, country_code=country_code)

    def create_super_account(self, account_id: str, id_type: str, password: str, country_code: str = '+91'):
        self._create_account(account_id, id_type, timezone.now().date(), password, True, True, country_code=country_code)


class Account(AbstractBaseUser, PermissionsMixin):
    # emailId or phone number without country code
    account_id = models.CharField(max_length=70, default='account_id', primary_key=True)
    id_type = models.CharField(max_length=6, default='PHONE')  # PHONE or EMAIL
    joined_at = models.DateField(default=timezone.now())
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    object = AccountManager()
    USERNAME_FIELD = 'account_id'
    REQUIRED_FIELDS = ('id_type', 'joined_at')
