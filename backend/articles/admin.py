from django.contrib import admin
from .models import Chat, Review

class ChatAdmin(admin.ModelAdmin):
    list_display = ('pk', 'user', 'group', 'content', 'created_at')

class ReviewAdmin(admin.ModelAdmin):
    list_display = ('pk', 'item', 'group', 'content', 'reviewed', 'created_at')

admin.site.register(Chat, ChatAdmin)
admin.site.register(Review, ReviewAdmin)