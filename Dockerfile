FROM        python:3.6.4-slim
MAINTAINER  peter.s.han.1119@gmail.com

RUN         apt-get -y update
RUN         apt-get -y dist-upgrade
RUN         apt-get -y install nginx supervisor build-essential

COPY        .requirements /srv/.requirements

WORKDIR     /srv
RUN         pip install -r /srv/.requirements/dev.txt

COPY        . /srv/project

RUN         cp -f /srv/project/.config/local/nginx.conf /etc/nginx/nginx.conf &&\
            cp -f /srv/project/.config/local/nginx-app.conf /etc/nginx/sites-available/ &&\
            rm -f /etc/nginx/sites-enabled/* &&\
            ln -sf /etc/nginx/sites-available/nginx-app.conf /etc/nginx/sites-enabled/

RUN         cp -f /srv/project/.config/local/supervisord.conf /etc/supervisor/conf.d/

CMD         pkill nginx; supervisord -n