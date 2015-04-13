FROM debian:jessie
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
		&& rm -rf /var/lib/apt/lists/*

# start x11vnc and expose its port, which is 5900 + display number
EXPOSE 5901
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]