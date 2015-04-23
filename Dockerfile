FROM debian:jessie
MAINTAINER Jan Suchotzki <jan@suchotzki.de>

# first create user and group for all the X Window stuff
# required to do this first so have consistent uid/gid between server and client container
RUN addgroup --system xusers \
  && adduser \
			--home /home/xuser \
			--disabled-password \
			--shell /bin/bash \
			--gecos "user for running X Window stuff" \
			--ingroup xusers \
			--quiet \
			xuser

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
				x11-utils \
				x11-xserver-utils \
		&& rm -rf /var/lib/apt/lists/*

# create or use the volume depending on how container is run
# ensure that server and client can access the cookie
RUN mkdir -p /Xauthority && chown -R xuser:xusers /Xauthority
VOLUME /Xauthority

# start x11vnc and expose its port
ENV DISPLAY :0.0
EXPOSE 5900
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# switch to user and start
USER xuser
ENTRYPOINT ["/entrypoint.sh"]
