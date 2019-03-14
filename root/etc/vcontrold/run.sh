#!/bin/bash
# Konfiguration
#MQTT=true
#MQTTPUB=30

vcontrold -x /etc/vcontrold/vcontrold.xml -d /dev/ttyUSB1 -P /var/run/vcontrold.pid
status=$?
pid=$(pidof vcontrold)
if [ $status -ne 0 ];then
	echo "Failed to start vcontrold"
fi

if [ $MQTT = true ]; then
	echo "vcontrold gestartet (PID $pid)"
	echo "MQTT: aktiv (var = $MQTT)"
	echo "Aktualisierungsintervall: $MQTTPUB sec"
	while sleep $MQTTPUB; do
		vclient -h 127.0.0.1 -p 3002 -f /etc/vcontrold/1_mqtt_commands.txt -t /etc/vcontrold/2_mqtt.tmpl -x /etc/vcontrold/3_mqtt_pub.sh
		if [ -e /var/run/vcontrold.pid ]; then
			:
		else
			echo "vcontrold.pid nicht vorhanden, exit 0"
			exit 0
		fi
	done
else
	echo "vcontrold gestartet"
	echo "MQTT: inaktiv (var = $MQTT)"
	echo "PID: $pid"
	while sleep 600; do
		if [ -e /var/run/vcontrold.pid ]; then
			:
		else
			echo "vcontrold.pid nicht vorhanden, exit 0"
			exit 0
		fi
	done
fi
