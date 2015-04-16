#!/bin/sh
LOCALIP=`LC_ALL="en" ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '172.'`


echo "127.0.0.1 subsonic.org" >> /etc/hosts
set -e

[ ! -L /data-transcode ] && ln -s /var/subsonic.default/transcode /data-transcode

/usr/share/subsonic/subsonic.sh --host=$LOCALIP  & > /dev/null

#nmap -p- 127.0.0.1 
#echo `ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
#LOCALIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
#echo "LOCALIP: $LOCALIP"
#echo "$LOCALIP" > /data/ip
#echo "nmap $LOCALIP -p 1-65535 | grep open | awk {'print $1'} | awk -F"/" {'print $1'} | grep -v '4040\|9412' > /data/openports"
#echo `nmap $LOCALIP -p 1-65535`
#nmap $LOCALIP -p 1-65535 | grep open | awk {'print $1'} | awk -F"/" {'print $1'} | grep -v '4040\|9412' > /data/openports
#
#echo `cat /data/openports`

#do not exit container
while true
do
	sleep 1000
done

