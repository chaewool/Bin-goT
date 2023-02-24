from django.contrib import admin
from .models import Group, Participate

class GroupAdmin(admin.ModelAdmin):
    list_display = ('group_id', 'leader', 'groupname', 'headcount', 'start', 'end', 'size', 'description', 'rule', 'has_img', 'period', 'is_public', 'password', 'need_auth')

class ParticipateAdmin(admin.ModelAdmin):
    list_display = ('user', 'group', 'is_banned', 'rand_name')

admin.site.register(Group, GroupAdmin)
admin.site.register(Participate, ParticipateAdmin)