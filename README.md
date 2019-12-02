# levi-labs-docker-logging

## Agenda

1. App write log to console, then use a log shipper forward log to ES
2. App and log shipper share a volume, App write log to log files then log shipper forward log to ES (Side car pattern)

## 0. Building a Elasticsearch and Kibana

Lunch ES and Kibana with Docker Compose

~~~bash
cd lab0
docker-compose up -d
~~~

Connect to: http://localhost:5601/app/kibana
