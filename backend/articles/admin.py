from django.contrib import admin
from .models import Chat, Review

class ChatAdmin(admin.ModelAdmin):
    list_display = ('chat_id', 'user', 'group', 'content', 'created_at')

class ReviewAdmin(admin.ModelAdmin):
    list_display = ('review_id', 'item', 'group', 'content', 'reviewed', 'created_at')

admin.site.register(Chat, ChatAdmin)
admin.site.register(Review, ReviewAdmin)