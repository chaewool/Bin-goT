from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, Badge, Achieve
from groups.models import Group

class BadgeAdmin(admin.ModelAdmin):
    list_display = ('pk', 'badgename', 'badge_cond')

class AchieveAdmin(admin.ModelAdmin):
    list_display = ('pk', 'user', 'badge')
    
class GroupInline(admin.TabularInline):
    model = Group
    
class UserAdmin(admin.ModelAdmin):
    inlines = [
        GroupInline
    ]
    exclude = ('groups', )

admin.site.register(User, UserAdmin)
admin.site.register(Badge, BadgeAdmin)
admin.site.register(Achieve, AchieveAdmin)