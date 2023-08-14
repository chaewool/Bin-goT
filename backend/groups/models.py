from django.db import models
from django.conf import settings


class Group(models.Model):
    leader = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET(-1))
    groupname = models.CharField(max_length=20, unique=True)
    count = models.IntegerField(default=1)
    headcount = models.IntegerField()
    start = models.DateField()
    end = models.DateField()
    size = models.IntegerField()
    description = models.TextField(null=True)
    rule = models.TextField(null=True)
    has_img = models.BooleanField()
    period = models.IntegerField()
    is_public = models.BooleanField()
    password = models.CharField(max_length=20, null=True)
    need_auth = models.BooleanField()
    users = models.ManyToManyField(settings.AUTH_USER_MODEL, through="Participate", related_name="users")

    def __str__(self) -> str:
        return self.groupname


class Participate(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    is_banned = models.IntegerField(default=0) # 0은 승인 완료, 1은 승인 대기, 2는 승인 거절/강퇴
    rand_name = models.CharField(max_length=20, null=True)
    
    def __str__(self) -> str:
        return f'{self.group} - {self.user}'