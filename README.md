# levi-labs-docker-logging

## Agenda

1. App write log to console, then use a log shipper forward log to ES
2. App and log shipper share a volume, App write log to log files then log shipper forward log to ES (Side car pattern)

## 0. Building a Elasticsearch and Kibana

Lunch ES and Kibana with Docker Compose
Connect to: http://localhost:5601/app/kibana

~~~bash
cd lab0
docker-compose up -d
~~~

## 1. Lunch a logger shipper and a application

Lunch a logger shipper
~~~bash
cd lab1
docker build -t log-shipper -f Dockerfile-log-shipper .
docker run \
    -v /home/ubuntu/environment/levi-labs-docker-logging/lab1/filebeat.yml:/usr/share/filebeat/filebeat.yml \
    -v /var/lib/docker/containers/:/var/lib/docker/containers/ \
    --log-driver=none \
    log-shipper
~~~

lunch a application and input log in stdout
~~~bash
docker build -t lab1-app -f Dockerfile .
docker run lab1-app
~~~

