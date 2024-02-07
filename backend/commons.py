# 클라이언트로부터 전달받은 데이터 중 bool 타입 데이터 변환

def get_boolean(tmp):
    if type(tmp) == bool:
        return tmp
    return True if tmp in ('true', 'True') else False


# AWS S3에 이미지 저장 및 삭제

import boto3
from bingot_settings import AWS_S3_ACCESS_KEY_ID, AWS_S3_SECRET_ACCESS_KEY, AWS_S3_BUCKET_NAME, REDIS_PASSWORD

def upload_image(url, img):
    s3_client = boto3.client(
        's3',
        aws_access_key_id     = AWS_S3_ACCESS_KEY_ID,
        aws_secret_access_key = AWS_S3_SECRET_ACCESS_KEY
    )
    
    s3_client.upload_fileobj(
        img, 
        AWS_S3_BUCKET_NAME, 
        url, 
        ExtraArgs={
            "ContentType": img.content_type
        }
    )
    
def delete_image(url):
    s3_client = boto3.client(
        's3',
        aws_access_key_id     = AWS_S3_ACCESS_KEY_ID,
        aws_secret_access_key = AWS_S3_SECRET_ACCESS_KEY
    )
    
    s3_client.delete_object(
        Bucket=AWS_S3_BUCKET_NAME, 
        Key=url
    )


# Redis 0번 DB에서 그룹 별 랭킹 정보 조회 및 갱신

import redis
from urllib.parse import quote

encoded_password = quote(REDIS_PASSWORD, safe="")
conn_ranker = redis.from_url("redis://:{}@bingot.store:6379/0".format(encoded_password), decode_responses=True)

class RedisRanker:
    def __init__(self, key):
        self.conn_redis = conn_ranker
        self.key = key

    def plusOne(self, str_member):
        return int(self.conn_redis.zincrby(name=self.key, value=str_member, amount=1))

    def getScore(self, str_member):
        return int(self.conn_redis.zscore(name=self.key, value=str_member) or 0)
    
    def getRank(self, str_member):
        rank = self.conn_redis.zrevrank(name=self.key, value=str_member)
        if rank == None: return -1
        else: return int(rank) + 1
    
    def getTops(self, return_count=3):
        return self.conn_redis.zrevrangebyscore(name=self.key, min="-inf", max="+inf", start=0, num=return_count)


# Redis 1번 DB에서 그룹 별 채팅 정보 조회 및 갱신

import json

conn_chat = redis.from_url("redis://:{}@bingot.store:6379/1".format(encoded_password), decode_responses=True)

class RedisChat:
    def __init__(self, key):
        self.conn_redis = conn_chat
        self.key = key

    def getLength(self):
        return self.conn_redis.llen(self.key)

    def addChat(self, data):
        self.conn_redis.rpush(self.key, json.dumps(data))

    def getChatList(self, idx):
        if idx == 0:
            return [json.loads(item) for item in self.conn_redis.lrange(self.key, -50, -1)][::-1]
        else:
            length = self.conn_redis.llen(self.key)
            return [json.loads(item) for item in self.conn_redis.lrange(self.key, idx - length - 51, idx - length - 1)][::-1]
    
    def getChatItem(self, chat_id):
        return json.loads(self.conn_redis.lindex(self.key, chat_id))
    
    def setChatItem(self, chat_id, chat):
        self.conn_redis.lset(self.key, chat_id, json.dumps(chat))


# Redis 2번 DB에서 사용자 별 FCM 토큰 조회 및 갱신

conn_token = redis.from_url("redis://:{}@bingot.store:6379/2".format(encoded_password), decode_responses=True)

class RedisToken:
    def __init__(self):
        self.conn_redis = conn_token

    def getToken(self, user_id):
        return self.conn_redis.get(user_id)
    
    def setToken(self, user_id, token):
        self.conn_redis.set(user_id, token)


# FCM으로 알림 전송

from firebase_admin import messaging

def send_to_fcm(user, group, title, content, path, chat=None):
    token = RedisToken()

    # 한 명 빼고 모든 그룹원에게 전송(채팅)
    if group:
        registration_tokens = [token.getToken(temp.id) for temp in group.users.all() if temp != user]

        message = messaging.MulticastMessage(
            data={'title': title, 'content': content, 'data': json.dumps({'path': path, 'chat': chat})},
            tokens=registration_tokens,
        )

        messaging.send_multicast(message)
    # 개인에게 전송
    else:
        registration_token = token.getToken(user.id)

        message = messaging.Message(
            data={'title': title, 'content': content, 'data': json.dumps({'path': path})},
            token=registration_token,
        )

        messaging.send(message)


# 뱃지 알림 전송

from accounts.models import Badge, Achieve

def send_badge_notification(user, badge_id):
    badge = Badge.objects.get(id=badge_id)
    Achieve.objects.create(user=user, badge=badge)
    
    user.cnt_badge += 1
    user.save()
    
    title = '새로운 뱃지 획득!'
    content = '알림을 눌러 획득한 뱃지를 확인해보세요.'
    path = 'mypage'

    send_to_fcm(user, '', title, content, path)