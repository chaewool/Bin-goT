from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class ServiceTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        token['id'] = user.user_id
        token['username'] = user.username

        return token