FROM python:3.6.0-alpine

WORKDIR /app

RUN apk update && apk add gcc

COPY requirements.txt /app
RUN pip install -r /app/requirements.txt

COPY __init__.py /app
COPY crawler/ /app/crawler/

ENV MONGO mongo_db
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE crawler_queue
ENV RMQ_USERNAME guest
ENV RMQ_PASSWORD guest
ENV CHECK_INTERVAL 60
ENV EXCLUDE_URLS '.*github.com'
ENV URL 'https://vitkhab.github.io/search_engine_test_site/'

CMD export PYTHONUNBUFFERED=yes && python crawler/crawler.py ${URL}
