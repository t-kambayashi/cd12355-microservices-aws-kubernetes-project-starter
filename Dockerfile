FROM python:3.10-slim-buster

WORKDIR /analytics

RUN apt update -y \
    && apt install -y build-essential libpq-dev \
    && pip install --upgrade pip setuptools wheel

COPY ./analytics/requirements.txt requirements.txt
RUN pip install -r requirements.txt


ENV DB_USERNAME=myuser
ENV DB_PASSWORD=mypassword
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5434
ENV DB_NAME=mydatabase

COPY ./analytics .

RUN kubectl port-forward svc/postgresql-service $DB_PORT:5432 &
CMD ["python", "app.py"]
