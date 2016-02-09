#!/bin/bash
echo "127.0.0.1 subsonic.org" >> /etc/hosts
set -e

[ ! -L /data-transcode ] && ln -s /var/subsonic.default/transcode /data-transcode

#Install/Link Transcoders
mkdir -p /var/subsonic/transcode && \
cd /var/subsonic/transcode && \
ln -s "$(which ffmpeg)" && \
ln -s "$(which flac)" && \
ln -s "$(which lame)"

# enable/disable ssl based on env variable set from docker container run command
if [[ "$SSL" = "yes" ]]; then
	echo "Enabling SSL"
	port="--https-port=4050"
elif [[ "$SSL" = "no" ]]; then
	echo "Disabling SSL"
	port="--port=4040"
 fi

 # if context path not defined then set to empty string (default root context)
 if [[ -z "${CONTEXT_PATH}" ]]; then
	CONTEXT_PATH="/"
 fi

/usr/share/subsonic/subsonic.sh ${port} --context-path=${CONTEXT_PATH} --default-music-folder=/media --max-memory=1024
