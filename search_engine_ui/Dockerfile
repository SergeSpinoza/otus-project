FROM python:3.6.0-alpine

WORKDIR /app

RUN apk update && apk add gcc

COPY requirements.txt /app
RUN pip install -r /app/requirements.txt

COPY ui/ /app/ui/

ENV MONGO mongo_db
ENV MONGO_PORT 27017

CMD cd ui && FLASK_APP=ui.py gunicorn ui:app -b 0.0.0.0
