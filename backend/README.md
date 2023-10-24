# Bin-goT Backend & Infra

<br/> <br/> <br/>

## 1. 개발 설정

| 구분    | 이름                | 버전     |
| ------- | ------------------- | -------- |
| Backend |                     |          |
|         | Python              | 3.10.5   |
|         | Django              | 3.2.12   |
|         | djangorestframework | 3.14.0   |
|         | gunicorn            | 20.1.0   |
|         | mysqlclient         | 2.1.1    |
|         | django-redis        | 5.2.0    |
|         | boto3               | 1.26.92  |
|         | APScheduler         | 3.10.1   |
|         | firebase-admin      | 6.1.0    |
| Server  |                     |          |
|         | AWS EC2             | -        |
|         | AWS Route 53        | -        |
|         | Ubuntu              | 20.04    |
|         | Docker              | 20.10.23 |
|         | Docker Compose      | 1.25.0   |
|         | Jenkins             | 2.387.3  |
|         | Nginx               | 1.18.0   |
| DB      |                     |          |
|         | MySQL               | 8.0.34   |
|         | Redis               | 5.0.7    |
|         | AWS S3              | -        |

<br/> <br/> <br/>

## 2. 빌드 및 배포

1. Dockerfile 작성

```Dockerfile
FROM python:3.10.5
WORKDIR /var/jenkins_home/workspace/[젠킨스 프로젝트(아이템) 이름]/[백엔드 프로젝트 루트 폴더 이름]
COPY requirements.txt ./

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "[백엔드 프로젝트 이름].wsgi", "--bind", "0.0.0.0:8000"]
```

2. Jenkins 프로젝트에서 shell 명령어 작성

```shell
docker build -t backimg ./[장고 프로젝트 루트 폴더 이름]
if (docker ps | grep "backimg"); then docker stop backimg; fi
docker run -it -d --rm -p 8080:8080 --name backimg backimg
echo "Run Django"
```
