FROM debian:jessie
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# winetricks is located in the contrib repository
#RUN echo "deb http://http.debian.net/debian jessie contrib" > /etc/apt/sources.list.d/contrib.list

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
		&& rm -rf /var/lib/apt/lists/*

# Setup a password for vnc
RUN mkdir ~/.vnc \
		&& x11vnc -storepasswd myPW ~/.vnc/passwd

# start x11vnc and expose its port, which is 5900 + display number
EXPOSE 5901
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]