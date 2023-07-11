from django.db import models
from django.conf import settings


class Board(models.Model):
    group = models.ForeignKey('groups.Group', on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='boards')
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
    check_cnt = models.IntegerField(null=True) # 현재까지 수행한 횟수
    finished = models.BooleanField(default=False)

    def __str__(self) -> str:
        return f'{self.board} - {self.item_id}'