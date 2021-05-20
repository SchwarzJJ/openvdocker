FROM debian:latest
MAINTAINER Jens Schwarz <SchwarzJJ>
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y mosquitto-clients
COPY root / 
ENV OPTOLINK /dev/ttyUSB1
ENV IPMQTTBROKER 192.168.25.6
ENV PORTMQTTBROKER 1883
ENV MQTTTOPIC Vitoplus_300
ENV MQTTUSER openhab
ENV MQTTPWD password
ENV MQTT true
ENV MQTTPUB 30
EXPOSE 3002/udp
ENTRYPOINT ["sh","/etc/vcontrold/run.sh"]
