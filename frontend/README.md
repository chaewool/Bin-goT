# Bin-goT Frontend

<br/> <br/> <br/>

## 1. 개발 설정

| 구분     | 이름                        | 버전         |
| -------- | --------------------------- | ------------ |
| Frontend |                             |              |
|          | Dart                        | 3.0.6        |
|          | DevTools                    | 2.23.1       |
|          | Flutter                     | 3.10.6       |
|          | dio                         | 5.3.2        |
|          | intl                        | 0.18.0       |
|          | provider                    | 6.0.5        |
|          | share_plus                  | 7.1.0        |
|          | http_parser                 | 4.0.2        |
|          | flutter_html                | 3.0.0-beta.2 |
|          | image_picker                | 0.8.9        |
|          | path_provider               | 2.1.1        |
|          | flutter_dotenv              | 5.1.0        |
|          | webview_flutter             | 4.2.4        |
|          | device_info_plus            | 9.0.3        |
|          | package_info_plus           | 4.1.0        |
|          | permission_handler          | 10.4.5       |
|          | image_gallery_saver         | 2.0.3        |
|          | cached_network_image        | 3.2.3        |
|          | flutter_oss_licenses        | 2.0.1        |
|          | flutter_email_sender        | 6.0.1        |
|          | calendar_date_picker2       | 0.5.3        |
|          | contained_tab_bar_view      | 0.8.0        |
|          | firebase_dynamic_links      | 5.3.5        |
|          | firebase_core               | 2.15.1       |
|          | firebase_messaging          | 14.6.7       |
|          | flutter_secure_storage      | 9.0.0        |
|          | kakao_flutter_sdk_user      | 1.5.0        |
|          | kakao_flutter_sdk_share     | 1.5.0        |
|          | flutter_local_notifications | 14.1.3+1     |

<br/> <br/> <br/>

## 2. 빌드 및 배포

### 릴리즈 모드 테스트

1. frontend 파일 내에서 다음 명령어 입력

   ```
   flutter run --release
   ```



### 빌드/배포

1. pubspec.yaml, /android/local.properties, /android/app/build.gradle 파일에서 버전 변경

   - versionCode는 숫자 형태 (플레이 스토어 전산에서 앱을 구분하기 위해 만든것, 최신 앱이 숫자 더 크도록 설정)

   - versionName은 숫자.숫자.숫자 형태  (개발자 or 사람이 구분하기 위해서 보기 쉽게 만들어 둔 이름)

2. frontend 파일 내에서 appbundle 파일로 빌드

   ```
   flutter build appbundle
   ```

3. build/app/outputs/bundle/release 폴더 내의 app-release.aab를 구글 콘솔에 첨부
