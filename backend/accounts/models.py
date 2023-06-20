from django.db import models
from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    kakao_id = models.CharField(max_length=255, unique=True)
    username = models.CharField(max_length=20, unique=True)
    badge = models.IntegerField(default=1)
    noti_rank = models.BooleanField(default=True)
    noti_due = models.BooleanField(default=True)
    noti_chat = models.BooleanField(default=True)
    noti_check = models.BooleanField(default=True)
    cnt_groups = models.IntegerField(default=0)
    cnt_boards = models.IntegerField(default=0)
    cnt_boarditems_complete = models.IntegerField(default=0)
    cnt_boards_complete = models.IntegerField(default=0)
    cnt_rank1 = models.IntegerField(default=0)
    groups = models.ManyToManyField('groups.Group', through='groups.Participate', related_name="groups")

    def __str__(self) -> str:
        return self.username

class Badge(models.Model):
    badge_cond = models.CharField(max_length=100)

    def __str__(self) -> str:
        return self.badgename

class Achieve(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    
    def __str__(self) -> str:
        return f'{self.user} - {self.badge}'