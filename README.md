# levi-labs-docker-logging

## Agenda

1. App write log to console, then use a log shipper forward log to ES
2. App and log shipper share a volume, App write log to log files then log shipper forward log to ES (Side car pattern)

## 0. Building a Elasticsearch and Kibana

Lunch ES and Kibana with Docker Compose
Connect to: http://localhost:8080/app/kibana

~~~bash
cd lab0
# 0.1: start ES and Kibana
docker-compose up -d

# 0.2 build app: lds
docker build -t lds-app -f Dockerfile .
~~~

## Lab1. Lunch a logger shipper and a application

Lunch a logger shipper

~~~bash
cd lab1
# 1.1
docker build -t lab1-log-shipper \
    -f Dockerfile-log-shipper .

# 1.2 [MODIFY]
cp filebeat.template.yml filebeat.yml
## s/ES_IP/<your_local_ip>/

# 1.3 run log shipper
docker run \
    -v $PWD/filebeat.yml:/usr/share/filebeat/filebeat.yml \
    -v /var/lib/docker/containers/:/var/lib/docker/containers/ \
    --log-driver=none \
    lab1-log-shipper

~~~

lunch a application and input log in stdout

~~~bash
# 1.4 run app
docker run \
    --name lab1-app \
    lds-app
~~~

cleanup.

~~~bash
docker stop lab1-app lab1-log-shipper
~~~


## Lab2. Using Docker log driver and send log to std out

~~~bash
cd lab2
# 2.1 Launch a sidecar container
docker run -it -p 24224:24224 \
    --name lab2-log-shipper \
    -v $PWD/fluentd.conf:/fluentd/etc/fluentd.conf \
    -e FLUENTD_CONF=fluentd.conf fluent/fluentd:latest

# 2.2 Launch an App
docker run \
    --name lab2-app \
    --log-driver=fluentd \
    lds-app

~~~

Cleanup
~~~bash
docker stop lab2-app lab2-log-shipper
~~~

## Lab3. Using Docker log driver then send log to Elasticsearch

~~~bash
cd lab3
docker build \
    -f Docker-fluentd \
    -t lab3-fluentd-for-es .

docker run -it -p 24224:24224 \
    --name lab3-fluentd-for-es \
    -v $PWD/fluentd.conf:/fluentd/etc/fluentd.conf \
    -e FLUENTD_CONF=fluentd.conf lab3-fluentd-for-es

docker run \
    --name lab3-app \
    --log-driver=fluentd \
    lds-app
~~~