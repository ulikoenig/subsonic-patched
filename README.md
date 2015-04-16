# subsonic-patched

[Subsonic Source patched by Eugene E. Kashpureff Jr.](https://github.com/EugeneKay/subsonic)
It contains the [Subsonic](http://www.subsonic.org/) [sources](http://sourceforge.net/projects/subsonic/) with some patches. e.g. [Premium status](http://www.subsonic.org/pages/premium.jsp) is enabled by default without limits.

Warning: Build takes some Time and will download a lot of Data.

## Build Container

```
docker build -t ulikoenig/subsonic-patch https://raw.githubusercontent.com/ulikoenig/subsonic-patched/master/Dockerfile
```

## Run Container

```
$ docker run -d --net=host -p 4040:4040 -p 9412:9412 -v /var/lib/subsonic:/data:rw -v /mnt/harddrive/Medien:/Medien:ro  ulikoenig/subsonic-patch
```
I used
``` /var/lib/subsonic ```
as storage for the subsonic local database. So I can destroy the container and rebuild it without loosing the configuration an media database.

My media is stored in
``` /mnt/harddrive/Medien ```.

Please change this paths how you like it.

The Parameter ``` "--net=host" ``` is important to give subsonic access to the real external IP. Without this, Sonos support will not work, even if ports are open, because subsonic tells Sonos to make calls to 172.xx.xx.xx IP-adresses.

## Finally:

Open a Browser with http://YOUIPADDRESS:4040

## [Optional]  Setup Subsonic on Sonos Device

    Open http://SONOS_IP:1400/customsd.htm in a browser.

* Enter the following values in the web form:
 * SID – Any legal value EXCEPT 242. e.g. 243
 * Service Name – Any name, for instance "Subsonic Remote"
 * Endpoint URL – http://SUBSONIC_IP:4040/ws/Sonos?ip=SUBSONIC_IP
 * Secure Endpoint URL – http://SUBSONIC_IP:4040/ws/Sonos?ip=SUBSONIC_IP
 * Polling Interval – 1200
 * Authentication – Session ID
 * Strings Table – Version: 5, URI: http://SUBSONIC_IP:4040/sonos/strings.xml
 * Presentation Map – Version: 1, URI: http://SUBSONIC_IP:4040/sonos/presentationMap.xml
 * Container Type – Music Service
 * Capabilities – Search, Favorites, Extended Metadata

Source: http://www.subsonic.org/pages/sonos.jsp
