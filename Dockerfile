FROM centos:8
RUN yum update -y \
  && yum install -y vim nc
RUN echo -e "[influxdb]\nname = InfluxDB Repository - RHEL \$releasever\nenabled = 1\nbaseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable\ngpgcheck = 1\ngpgkey = https://repos.influxdata.com/influxdb.key" > /etc/yum.repos.d/influxdb.repo \
  && yum install -y influxdb \
  && sed -i '/\[http\]/a \  enabled = true\n  flux-enabled = true\n  bind-address = ":8086"' /etc/influxdb/influxdb.conf 
ENTRYPOINT influxd -config /etc/influxdb/influxdb.conf
