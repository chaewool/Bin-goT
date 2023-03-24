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
    
import redis

conn_redis = redis.StrictRedis(host="127.0.0.1", port=6379, db=1, password=REDIS_PASSWORD, decode_responses=True)

class RedisRanker:
    def __init__(self, key, is_ranker_reset=True):
        self.conn_redis = conn_redis
        self.key  = key
        if is_ranker_reset is True:
            self.conn_redis.delete(self.key)

    def plusOne(self, str_member):
        return int(self.conn_redis.zincrby(name=self.key, value=str_member, amount=1))

    def getScore(self, str_member):
        return int(self.conn_redis.zscore(name=self.key, value=str_member) or 0)
    
    def getRank(self, str_member):
        return int(self.conn_redis.zrevrank(name=self.key, value=str_member) or -2) + 1
    
    def getTops(self, return_count=3):
        return conn_redis.zrevrangebyscore(name=self.key, min="-inf", max="+inf", start=0, num=return_count)