#!/bin/sh

sudo service ntp stop
sudo ntpd -gq
sudo service ntp start

java -jar /home/pi/Desktop/Attendance/attendance.jar
