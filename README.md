##About
Docker Image for creating a service container providing an X11-Server in conjunction with a VNC-Server. It allows to get the display of an application running inside a docker container to the host or any other machine accessing the VNC-Server.

It is intended to be used in conjunction with at least one other container hosting the application requiring an X-Server (aka X-Client). This differentiates it from other solutions running the X-Server, the VNC-Server and the X-Client in the same container.

My intention for this image was to have a clear separation of concerns. This image is responsible for all the X-Server stuff. Another image can fully concentrate on the application and is simply linked to a container of this image.

##Usage

##Maintenance
The image is build on Docker hub with [Automated builds](http://docs.docker.com/docker-hub/builds/). Also a [repository link](http://docs.docker.com/docker-hub/builds/#repository-links) to its parent image is configured. So it is automatically updated, when the parent image is updated.

##Copyright free
The sources in [this](https://github.com/suchja/x11-vnc-server.git) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
