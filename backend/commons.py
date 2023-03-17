import boto3
from bingot_settings import AWS_S3_ACCESS_KEY_ID, AWS_S3_SECRET_ACCESS_KEY, AWS_S3_BUCKET_NAME

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