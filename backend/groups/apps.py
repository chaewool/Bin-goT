import os

from django.apps import AppConfig


class GroupsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'groups'

    def ready(self):
        if os.environ.get('RUN_MAIN'):
            from . import scheduler
            scheduler.start()