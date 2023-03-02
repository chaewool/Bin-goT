from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    kakao_id = models.CharField(max_length=255, unique=True, null=False)
    username = models.CharField(max_length=20, unique=True, null=False)
    profile = models.IntegerField(null=False, default=0)
    noti_rank = models.BooleanField(null=False, default=True)
    noti_due = models.BooleanField(null=False, default=True)
    noti_chat = models.BooleanField(null=False, default=True)

    def __str__(self) -> str:
        return self.username

class Badge(models.Model):
    badgename = models.CharField(max_length=20, unique=True, null=False)
    badge_cond = models.CharField(max_length=100, null=False)

    def __str__(self) -> str:
        return self.badgename

class Achieve(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    
    def __str__(self) -> str:
        return f'{self.user} - {self.badge}'