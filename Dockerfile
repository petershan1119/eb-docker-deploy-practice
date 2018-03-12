FROM        petershan1119/eb-docker:base
MAINTAINER  peter.s.han.1119@gmail.com

# apt-get으로 nginx, supervisor설치
RUN         apt-get -y update
RUN         apt-get -y dist-upgrade
RUN         apt-get -y install build-essential nginx supervisor

# requirements만 복사
COPY        .requirements /srv/.requirements

# pip install
WORKDIR     /srv
RUN         pip install -r /srv/.requirements/production.txt

ENV         BUILD_MODE              production
ENV         DJANGO_SETTINGS_MODULE  config.settings.${BUILD_MODE}

# 소스폴더를 통째로 복사
COPY        . /srv/project

# nginx설정파일을 복사 및 링크
RUN         cp -f   /srv/project/.config/${BUILD_MODE}/nginx.conf       /etc/nginx/nginx.conf &&\
            cp -f   /srv/project/.config/${BUILD_MODE}/nginx-app.conf   /etc/nginx/sites-available/ &&\
            rm -f   /etc/nginx/sites-enabled/* &&\
            ln -sf  /etc/nginx/sites-available/nginx-app.conf           /etc/nginx/sites-enabled/

# supervisor설정파일을 복사
RUN         cp -f   /srv/project/.config/${BUILD_MODE}/supervisord.conf /etc/supervisor/conf.d/

# pkill nginx후 supervisord -n실행
CMD         pkill nginx; supervisord -n
EXPOSE      80