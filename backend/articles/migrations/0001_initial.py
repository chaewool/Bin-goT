# Generated by Django 3.2.12 on 2023-02-28 10:06

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('groups', '0001_initial'),
        ('boards', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Chat',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('content', models.TextField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='groups.group')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='File',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('filename', models.CharField(max_length=255)),
                ('filetype', models.CharField(max_length=4)),
            ],
        ),
        migrations.CreateModel(
            name='Review',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('content', models.TextField()),
                ('reviewed', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('group', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='groups.group')),
                ('item', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='boards.boarditem')),
            ],
        ),
        migrations.CreateModel(
            name='ReviewImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('file', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.file')),
                ('review', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.review')),
            ],
        ),
        migrations.CreateModel(
            name='ChatImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('chat', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.chat')),
                ('file', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='articles.file')),
            ],
        ),
    ]
