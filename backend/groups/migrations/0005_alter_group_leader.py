# Generated by Django 3.2.20 on 2023-10-23 00:41

from django.conf import settings
from django.db import migrations, models
import groups.models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('groups', '0004_alter_boarditem_check_goal'),
    ]

    operations = [
        migrations.AlterField(
            model_name='group',
            name='leader',
            field=models.ForeignKey(on_delete=models.SET(groups.models.set_no_leader), to=settings.AUTH_USER_MODEL),
        ),
    ]