from django.db import models
from django.conf import settings
from django.core.validators import MinValueValidator, MaxValueValidator

class Group(models.Model):
    leader = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.DO_NOTHING)
    groupname = models.CharField(max_length=20)
    count = models.IntegerField(default=1, validators=[MinValueValidator(1), MaxValueValidator(30)])
    headcount = models.IntegerField(validators=[MinValueValidator(2), MaxValueValidator(30)])
    start = models.DateField()
    end = models.DateField()
    size = models.IntegerField(validators=[MinValueValidator(2), MaxValueValidator(5)])
    description = models.TextField(null=True)
    rule = models.TextField(null=True)
    has_img = models.BooleanField()
    period = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    is_public = models.BooleanField()
    password = models.CharField(max_length=20, null=True)
    need_auth = models.BooleanField()
    users = models.ManyToManyField(settings.AUTH_USER_MODEL, through="Board", related_name="users")
    status = models.IntegerField(default=0, validators=[MinValueValidator(-1), MaxValueValidator(2)]) # -1은 시작 전 폐기, 0은 시작 전, 1은 진행 중, 2는 완료

    def __str__(self) -> str:
        return self.groupname


class Board(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='boards')
    group = models.ForeignKey('groups.Group', on_delete=models.CASCADE, related_name='boards')
    is_banned = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(2)]) # 0은 승인 완료, 1은 승인 대기, 2는 승인 거절/강퇴
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
    content = models.CharField(null=True, max_length=100)
    check = models.BooleanField() # 횟수 측정 여부
    check_goal = models.IntegerField(default=0) # 목표 횟수
    check_cnt = models.IntegerField(default=0) # 현재까지 수행한 횟수
    finished = models.BooleanField(default=False)

    def __str__(self) -> str:
        return f'{self.board} - {self.item_id}'