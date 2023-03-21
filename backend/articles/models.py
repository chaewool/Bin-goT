from django.db import models
from django.conf import settings
from groups.models import Group
from boards.models import BoardItem

class Chat(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'[{self.created_at}] {self.group} - {self.user} : {self.content}'

class Review(models.Model):
    item = models.ForeignKey(BoardItem, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    content = models.TextField()
    reviewed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'[{self.created_at}] {self.group} - {self.item} : {self.content}'

class File(models.Model):
    filename = models.CharField(max_length=255)
    filetype = models.CharField(max_length=4)

    def __str__(self) -> str:
        return f'{self.filename}'

class ChatImage(models.Model):
    chat = models.ForeignKey(Chat, on_delete=models.CASCADE)
    file = models.ForeignKey(File, on_delete=models.CASCADE)

    def __str__(self) -> str:
        return f'{self.chat} - {self.file}'

class ReviewImage(models.Model):
    review = models.ForeignKey(Review, on_delete=models.CASCADE)
    file = models.ForeignKey(File, on_delete=models.CASCADE)

    def __str__(self) -> str:
        return f'{self.review} - {self.file}'