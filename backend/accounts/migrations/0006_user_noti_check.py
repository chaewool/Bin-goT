# Generated by Django 3.2.12 on 2023-06-20 12:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0005_rename_profile_user_badge'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='noti_check',
            field=models.BooleanField(default=True),
        ),
    ]
