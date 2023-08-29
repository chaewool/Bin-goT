from django.contrib import admin
from .models import Group, Board

class GroupAdmin(admin.ModelAdmin):
    list_display = ('pk', 'leader', 'groupname', 'headcount', 'start', 'end', 'size', 'description', 'rule', 'has_img', 'period', 'is_public', 'password', 'need_auth')

class BoardAdmin(admin.ModelAdmin):
    list_display = ('pk', 'user', 'group', 'is_banned', 'rand_name')

admin.site.register(Group, GroupAdmin)
admin.site.register(Board, BoardAdmin)