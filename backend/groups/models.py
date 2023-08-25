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
    users = models.ManyToManyField(settings.AUTH_USER_MODEL, through="Board", related_name="users")

    def __str__(self) -> str:
        return self.groupname


class Board(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='boards')
    group = models.ForeignKey('groups.Group', on_delete=models.CASCADE)
    is_banned = models.IntegerField(default=0) # 0은 승인 완료, 1은 승인 대기, 2는 승인 거절/강퇴
    rand_name = models.CharField(max_length=20, null=True)
    title = models.CharField(max_length=20)
    background = models.IntegerField(null=True)
    is_black = models.BooleanField(default=False)
    has_border = models.BooleanField(default=False)
    has_round_edge = models.BooleanField(default=False)
    around_kan = models.IntegerField(default=0)
    complete_icon = models.IntegerField(default=0)
    font = models.IntegerField()

    def __str__(self) -> str:
        return f'{self.group} - {self.user} : {self.title}'


class BoardItem(models.Model):
    board = models.ForeignKey(Board, on_delete=models.CASCADE, related_name='items')
    item_id = models.IntegerField(default=0)
    title = models.CharField(max_length=20)
    content = models.CharField(max_length=100)
    check = models.BooleanField() # 횟수 측정 여부
    check_goal = models.IntegerField(null=True) # 목표 횟수
    check_cnt = models.IntegerField(default=0) # 현재까지 수행한 횟수
    finished = models.BooleanField(default=False)

    def __str__(self) -> str:
        return f'{self.board} - {self.item_id}'