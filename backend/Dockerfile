FROM python:3.9.16
WORKDIR /var/jenkins_home/workspace/bingot/backend
COPY requirements.txt ./

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
COPY . .