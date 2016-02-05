#!/bin/sh
if [ -z "$LOCALIP" ]; then
	LOCALIP=`LC_ALL="en" ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '172.'`
fi

echo "127.0.0.1 subsonic.org" >> /etc/hosts
set -e

[ ! -L /data-transcode ] && ln -s /var/subsonic.default/transcode /data-transcode

/usr/share/subsonic/subsonic.sh --host=$LOCALIP --max-memory=1024   & > /dev/null

#do not exit container
while true
do
	sleep 1000
done

