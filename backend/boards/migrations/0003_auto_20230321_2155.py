# Generated by Django 3.2.12 on 2023-03-21 12:55

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('boards', '0002_auto_20230321_1333'),
    ]

    operations = [
        migrations.AlterField(
            model_name='board',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='boards', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='boarditem',
            name='board',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', to='boards.board'),
        ),
    ]