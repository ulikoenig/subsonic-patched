FROM ubuntu:14.04
#CMDBUILD	docker build -t ulikoenig/subsonic-patched docker build -t ulikoenig/subsonic-patch https://raw.githubusercontent.com/ulikoenig/subsonic-patched/master/Dockerfile
#CMDRUN		docker run -d --net=host -p 4040:4040 -p 9412:9412 -v /var/lib/subsonic:/data:rw -v /mnt/harddrive/Medien:/Medien:ro  ulikoenig/subsonic-patched

MAINTAINER Uli König <docker@ulikoenig.de.nospam> (@u98)

ENV	JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN	apt-get update && \
#Flac, Lame, FFMPEG, Oracle Java JDK
	apt-get install -y software-properties-common python-software-properties flac lame && \
	add-apt-repository -y ppa:mc3man/trusty-media && \
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	apt-get install -y oracle-java8-installer ffmpeg maven git lintian fakeroot && \
#Download Sources from Git
	git clone git://github.com/EugeneKay/subsonic.git && \
	cd /subsonic && \
	git checkout release && \
#Build Sources from Scratch
	mvn package && \
	mvn -P full -pl subsonic-booter -am install && \
	mvn -P full -pl subsonic-installer-debian/ -am install && \
#Install Subsonic
	dpkg -i ./subsonic-installer-debian/target/subsonic-*.deb && \
#Remove unnecessary files
	rm -r -f /subsonic /root/.m2 && \
	apt-get purge -y maven git lintian fakeroot software-properties-common python-software-properties && \
	apt-get autoremove -y && \
 	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer 

RUN	mv /var/subsonic /var/subsonic.default && \
	ln -s /data /var/subsonic 

#Install/Link Transcoders
RUN	mkdir -p /var/lib/subsonic/transcode && \
	cd /var/lib/subsonic/transcode && \
	ln -s "$(which ffmpeg)" && \
	ln -s "$(which flac)" && \
	ln -s "$(which lame)"


# Don't fork to the background
RUN	sed -i "s/ > \${LOG} 2>&1 &//" /usr/share/subsonic/subsonic.sh 

RUN	sed -i "17d" /etc/default/subsonic && \
	sed -i "i1SUBSONIC_ARGS=\"--port=4040 --https-port=4443 --max-memory=200\"" /etc/default/subsonic

VOLUME	["/data"]
VOLUME	["/Media"]
EXPOSE	4040
EXPOSE	9412

ADD	start.sh /start.sh
CMD	["/start.sh"]
