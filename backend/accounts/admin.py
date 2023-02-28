from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, Badge, Achieve

class BadgeAdmin(admin.ModelAdmin):
    list_display = ('pk', 'badgename', 'badge_cond')

class AchieveAdmin(admin.ModelAdmin):
    list_display = ('pk', 'user', 'badge')

admin.site.register(User, UserAdmin)
admin.site.register(Badge, BadgeAdmin)
admin.site.register(Achieve, AchieveAdmin)