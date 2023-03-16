from django.db import models
from django.conf import settings

class Group(models.Model):
    leader = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET(-1))
    groupname = models.CharField(max_length=20, unique=True, null=False)
    headcount = models.IntegerField(null=False)
    start = models.DateField(null=False)
    end = models.DateField(null=False)
    size = models.IntegerField(null=False)
    description = models.TextField()
    rule = models.TextField()
    has_img = models.BooleanField(null=False)
    period = models.IntegerField(null=False)
    is_public = models.BooleanField(null=False)
    password = models.CharField(max_length=20)
    need_auth = models.BooleanField(null=False)
    users = models.ManyToManyField(settings.AUTH_USER_MODEL, through="Participate", related_name="users")

    def __str__(self) -> str:
        return self.groupname

class Participate(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    is_banned = models.BooleanField(null=False)
    rand_name = models.CharField(max_length=20)
    
    def __str__(self) -> str:
        return f'{self.group} - {self.user}'