from django.contrib import admin
from .models import Board, BoardItem

class BoardAdmin(admin.ModelAdmin):
    list_display = ('pk', 'group', 'user', 'title', 'background', 'is_black', 'has_border', 'has_round_edge', 'around_kan', 'complete_icon', 'font')

class BoardItemAdmin(admin.ModelAdmin):
    list_display = ('pk', 'board', 'item_id', 'title', 'content', 'check', 'check_goal', 'check_cnt', 'finished')

admin.site.register(Board, BoardAdmin)
admin.site.register(BoardItem, BoardItemAdmin)