from django.db import models
from django.conf import settings
from groups.models import Group

class Board(models.Model):
    board_id = models.AutoField(primary_key=True, db_column='board_id')
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    title = models.CharField(max_length=20, unique=True, null=False)
    background = models.IntegerField(null=False)
    color_text = models.CharField(max_length=6, null=False)
    color_line = models.CharField(max_length=6, null=False)
    line_style = models.IntegerField(null=False)
    font = models.IntegerField(null=False)

    def __str__(self) -> str:
        return f'{self.group} - {self.user} : {self.title}'

class BoardItem(models.Model):
    item_id = models.AutoField(primary_key=True, db_column='item_id')
    board = models.ForeignKey(Board, on_delete=models.CASCADE)
    content = models.CharField(max_length=100, null=False)
    check = models.BooleanField(null=False)
    check_goal = models.IntegerField()
    check_cnt = models.IntegerField()
    finished = models.BooleanField(null=False, default=False)

    def __str__(self) -> str:
        return f'{self.board} - {self.item_id}'