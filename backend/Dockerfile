FROM python:3.9.16
WORKDIR /var/jenkins_home/workspace/bingot/backend
COPY requirements.txt ./

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
COPY . .

# for django-crontab
# 권한 설정
RUN chmod -R 777 ./
RUN apt-get update

# cron 설치 및 로그 파일 생성
RUN apt-get install -y cron && touch ./files/log/cron.log