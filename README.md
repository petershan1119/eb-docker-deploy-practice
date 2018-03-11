# EB Docker Deploy

Docker 배포를 연습하는 프로젝트입니다.
`.secrets`폴더내의 파일로 비밀 키를 관리합니다.

## 환경 구분

### local

외부 서비스 접근 없이 개발 환경만을 사용 (DB와 Storage를 전부 로컬환경에서 구성)

## Requirements

- Python (3.6)
- PostgreSQL

## Installation

```
pip install -r requirements.txt
```

## Secrets

**`.secrets/base.json`**

```
{
  "SECRET_KEY": "<Django settings SECRET_KEY value>",
  "RAVEN_CONFIG": {
    "dsn": "https://<SecurityToekn>@sentry.io/...",
    "release": "raven.fetch_git_sha(os.path.abspath(os.pardir))"
  },
  "SUPERUSER_USERNAME": "<username>",
  "SUPERUSER_PASSWORD": "<password>",
  "SUPERUSER_EMAIL": "<email>"
}
```