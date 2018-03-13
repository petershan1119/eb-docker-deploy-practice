# EB Docker Deploy

Elastic Beanstalk에 Nginx-uWSGI-Django로 구성된 Docker 이미지를 배포합니다.

## Requirements

### 공통사항

- Python (3.6)
- .secrets/의 JSON파일 

### AWS환경 테스트

- Python (3.6)
- S3 Bucket, 해당 Bucket을 사용할 수 있는 IAM User의 AWS Access Key, Secret Access Key
- RDS Database (보안 그룹 허용 필요), 해당 Database를 사용할 수 있는 RDS의 User, Password

## Installation (Django runserver)

### 로컬 테스트 환경

```
pip install -r .requirements/dev.txt
python manage.py runserver
```

### AWS 환경

```
export DJANGO_SETTINGS_MODULE=config.settings.dev
pip install -r .requirements/dev.txt

```

### 배포 환경

```
export DJANGO_SETTINGS_MODULE=config.settings.production
pip install -r .requirements/dev.txt
python manage.py runserver

```

## Installation (Docker)

### 로컬 환경

`localhost:8000`에서 확인
```
docker build -t eb-docker:local -f Dockerfile.local
docker run --rm -it 8000:80 eb-docker:local

```

## DockerHub 관련

apt, pip 관련 내용을 미리 빌드해서 DockerHub 저장소에 업로드


```
docker build -t eb-docker:base -f Dockerfil.base
docker tag eb-docker:base <자신의 사용자명>/<저장소명>:base
docker push <사용자명>/<저장소명>:base
```

이후 ElasticBeanstalk을 사용한 배포 시, 해당 이미지를 사용

```dockerfile
FROM    <사용자명>/<저장소명>:base
...
...
```

## Secrets

### .secrets/base.json

```
{
  "SECRET_KEY": "<Django secret key>,
  "RAVEN_CONFIG": {
    "dsn": "https://<Sentry secret key>@sentry.io/298196",
    "release": "raven.fetch_git_sha(os.path.abspath(os.pardir))"
  },
  "SUPERUSER_USERNAME": "<Default superuser username>",
  "SUPERUSER_PASSWORD": "<Default superuser password>",
  "SUPERUSER_EMAIL": "<Default superuser email>",
  "AWS_ACCESS_KEY_ID": "<AWS access key (Permission: S3)>",
  "AWS_SECRET_ACCESS_KEY": "<AWS secret access key>",
  "AWS_STORAGE_BUCKET_NAME": "<AWS storage bucket name>",
  "AWS_DEFAULT_ACL": "private",
  "AWS_S3_REGION_NAME": "ap-northeast-2",
  "AWS_S3_SIGNATURE_VERSION": "s3v4"
}
```