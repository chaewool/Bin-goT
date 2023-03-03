from django.contrib import admin
from .models import Board, BoardItem

class BoardAdmin(admin.ModelAdmin):
    list_display = ('pk', 'group', 'user', 'title', 'background', 'color_text', 'color_line', 'line_style', 'font')

class BoardItemAdmin(admin.ModelAdmin):
    list_display = ('pk', 'board', 'content', 'check', 'check_goal', 'check_cnt', 'finished')

admin.site.register(Board, BoardAdmin)
admin.site.register(BoardItem, BoardItemAdmin)