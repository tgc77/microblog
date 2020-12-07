FROM python:3.9.0-alpine

RUN adduser -D microblog

WORKDIR /home/microblog

COPY requirements.txt requirements.txt
RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install wheel
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn pymysql
RUN apk add redis
RUN apk add gcc
RUN apk add --no-cache libressl-dev musl-dev libffi-dev
RUN venv/bin/pip install --no-cache-dir cryptography

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh rq-startup.sh ./
RUN chmod +x boot.sh
RUN chmod +x rq-startup.sh

ENV FLASK_APP microblog.py
COPY .env .env

RUN chown -R microblog:microblog ./ 
USER microblog

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]