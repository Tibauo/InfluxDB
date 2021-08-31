# InfluxDB

## Influx db

## Dockerfile
```
## En se basant sur une image de type CENTOS en version 8
FROM centos:8
## Mettre à jour l'image et installer des outils de debugs
RUN yum update -y \
  && yum install -y vim nc
## Ajout des repos influxdb et installation et configuration
RUN echo -e "[influxdb]\nname = InfluxDB Repository - RHEL \$releasever\nenabled = 1\nbaseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable\ngpgcheck = 1\ngpgkey = https://repos.influxdata.com/influxdb.key" > /etc/yum.repos.d/influxdb.repo \
  && yum install -y influxdb \
  && sed -i '/\[http\]/a \  enabled = true\n  flux-enabled = true\n  bind-address = ":8086"' /etc/influxdb/influxdb.conf
## Mise en route d'influxdb
ENTRYPOINT influxd -config /etc/influxdb/influxdb.conf
```

## Construire le container

```
tdiprima@ansible:influx [130] $ sudo docker build . -t influxdb
Sending build context to Docker daemon  57.34kB
Step 1/4 : FROM centos:8
 ---> 0d120b6ccaa8
Step 2/4 : RUN yum update -y   && yum install -y vim nc
 ---> Using cache
 ---> 4e31f7255572
Step 3/4 : RUN echo -e "[influxdb]\nname = InfluxDB Repository - RHEL \$releasever\nenabled = 1\nbaseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable\ngpgcheck = 1\ngpgkey = https://repos.influxdata.com/influxdb.key" > /etc/yum.repos.d/influxdb.repo   && yum install -y influxdb   && sed -i '/\[http\]/a \  enabled = true\n  flux-enabled = true\n  bind-address = ":8086"' /etc/influxdb/influxdb.conf
 ---> Using cache
 ---> aafd6d2eb5fa
Step 4/4 : ENTRYPOINT influxd -config /etc/influxdb/influxdb.conf
 ---> Using cache
 ---> c63b9647182a
Successfully built c63b9647182a
Successfully tagged influxdb:latest
```

## Demarrer le container
```
tdiprima@ansible:influx [0] $ sudo docker run -d -p 8088:8088 -p 8086:8086 --name influxdb influxdb
66c1a120c17ae37f246db852add48de0398a41340a8626a65d3974be317c2696
```
## Detruire le container
```
tdiprima@ansible:influx [0] $ sudo docker rm influxdb -f                                                                                                                                                                                                                       influxdb                                                                                                                                                                                                                                                                       
```

## Request
```
tdiprima@ansible:~/graf-influx/influx$ curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE mydb"
HTTP/1.1 200 OK
Content-Type: application/json
Request-Id: ccb470a9-193c-11eb-8001-0242ac110002
X-Influxdb-Build: OSS
X-Influxdb-Version: 1.8.3
X-Request-Id: ccb470a9-193c-11eb-8001-0242ac110002
Date: Wed, 28 Oct 2020 16:44:08 GMT
Transfer-Encoding: chunked

{"results":[{"statement_id":0}]}
delete db: curl -XPOST 'http://localhost:8086/query?db=mydb' --data-urlencode 'q=DROP DATABASE mydb'
```
