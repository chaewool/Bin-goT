from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import boto3
from datetime import datetime
import json

from bingot_settings import AWS_S3_ACCESS_KEY_ID, AWS_S3_SECRET_ACCESS_KEY, AWS_S3_BUCKET_NAME
from commons import SUCCESS, FAIL
from .serializers import GroupCreateSerializer

class GroupCreateView(APIView):
    def post(self, request):
        user = request.user
        img = request.FILES.get('img')
        data = json.loads(request.data.get('data'))
        
        period = (datetime.strptime(data.get('end'), '%Y-%m-%d') - datetime.strptime(data.get('start'), '%Y-%m-%d')).days

        headcount = data.get('headcount')
        size = data.get('size')
        is_public = data.get('is_public')
        password = data.get('password')
        
        if period > 365 or headcount < 1 or headcount > 30 or size < 2 or size > 5 or (is_public and password == ''):
            return Response(data=FAIL, status=status.HTTP_400_BAD_REQUEST)
        
        if 271 <= period <= 365:
            period = 4
        elif 181 <= period:
            period = 3
        elif 91 <= period:
            period = 2
        elif 31 <= period:
            period = 1
        else:
            period = 0
        
        serializer = GroupCreateSerializer(data=data)
        if serializer.is_valid(raise_exception=True):
            if img != None:
                serializer.save(leader=user, period=period, has_img=True)
                
                s3_client = boto3.client(
                    's3',
                    aws_access_key_id     = AWS_S3_ACCESS_KEY_ID,
                    aws_secret_access_key = AWS_S3_SECRET_ACCESS_KEY
                )
                url = 'groups' + '/' + str(serializer.data.get('id'))
                
                s3_client.upload_fileobj(
                    img, 
                    AWS_S3_BUCKET_NAME, 
                    url, 
                    ExtraArgs={
                        "ContentType": img.content_type
                    }
                )
            else:
                serializer.save(leader=user, period=period, has_img=False)
        
        data = {**SUCCESS, 'group_id': serializer.data.get('id')}
            
        return Response(data=data, status=status.HTTP_200_OK)


class GroupDetailView(APIView):
    def get(self, request):
        
        return Response(data=SUCCESS, status=status.HTTP_200_OK)


class GroupUpdateView(APIView):
    def update(self, request):
        
        return Response(data=SUCCESS, status=status.HTTP_200_OK)


class GroupDeleteView(APIView):
    def delete(self, request):
        
        return Response(data=SUCCESS, status=status.HTTP_200_OK)