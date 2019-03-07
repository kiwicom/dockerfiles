FROM ubuntu:16.04

RUN /usr/bin/apt-get update -q && \
    /usr/bin/apt-get install -qqy build-essential git && \
    /usr/bin/apt-get install -qqy python-pip python-dev && \
    /usr/bin/apt-get install -qqy uwsgi uwsgi-plugin-python && \
    /usr/bin/apt-get clean && \
    /bin/rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /bin/mkdir /opt/web-app && \
    cd /opt/web-app && \
    /usr/bin/git clone https://github.com/kiwicom/Jackalope.git /opt/web-app && \
    /bin/cp docker/web/web-app.ini /etc/uwsgi/apps-enabled/ && \
    /usr/bin/pip install -r requirements.txt && \
    /bin/chown -R www-data:www-data /opt/web-app

CMD ["uwsgi", "--ini", "/etc/uwsgi/apps-enabled/web-app.ini"]

LABEL name=jackalope version=dev \
    maintainer="Tomas Hudec <tomas.hudec@kiwi.com>"
