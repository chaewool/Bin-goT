# Generated by Django 3.2.12 on 2023-06-20 12:58

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('groups', '0007_alter_participate_is_banned'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='review',
            name='group',
        ),
        migrations.RemoveField(
            model_name='review',
            name='item',
        ),
        migrations.RemoveField(
            model_name='review',
            name='user',
        ),
        migrations.DeleteModel(
            name='Chat',
        ),
        migrations.DeleteModel(
            name='Review',
        ),
    ]
