# Generated by Django 3.2.12 on 2023-08-15 12:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0007_alter_user_badge'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='cnt_badge',
            field=models.IntegerField(default=0),
        ),
    ]