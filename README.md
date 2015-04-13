##About
Docker Image for creating a service container providing an framebuffered X11-Server ([xvfb](http://www.x.org/archive/X11R7.6/doc/man/man1/Xvfb.1.xhtml)) in conjunction with a VNC-Server ([x11vnc](http://www.karlrunge.com/x11vnc/)). It allows to get the display of an application running inside a docker container to the host or any other machine accessing the VNC-Server.

It is intended to be used in conjunction with at least one other container hosting the application requiring an X-Server (aka X-Client). This differentiates it from other solutions running the X-Server, the VNC-Server and the X-Client in the same container.

My intention for this image was to have a clear separation of concerns. This image is responsible for all the X-Server stuff. Another image can fully concentrate on the application and is simply linked to a container of this image.

##Usage

**ATTENTION:** This image is currently under development. Especially security is not considered. So please be aware of this when using it. When development is completed, passwords and other security aspects will be documented here.

###Environment Variables
When you start the `x11-service` image, you should adjust at least some of its configuration.

`VNC_PASSWORD`

This variable is mandatory and specifies the password you need to enter into your VNC-client when connecting to the VNC-Server running in a container from this image.

##Maintenance
The image is build on Docker hub with [Automated builds](http://docs.docker.com/docker-hub/builds/). There is no dedicated maintenance schedule for this image. It is relying on packages from `debian:jessie` and thus I do not assume to update it frequently.

In case you have any issues, you are invited to create a pull request or an issue on the related [github repository](https://github.com/suchja/x11-service).

##Copyright free
The sources in [this](https://github.com/suchja/x11-vnc-server.git) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
