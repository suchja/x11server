## About
Docker Image for creating a service container providing an framebuffered X11-Server ([xvfb](http://www.x.org/archive/X11R7.6/doc/man/man1/Xvfb.1.xhtml)) in conjunction with a VNC-Server ([x11vnc](http://www.karlrunge.com/x11vnc/)). It allows to get the display of an application running inside a docker container to the host or any other machine accessing the VNC-Server.

It is intended to be used in conjunction with at least one other container hosting the application requiring an X-Server (aka X-Client). This differentiates it from other solutions running the X-Server, the VNC-Server and the X-Client in the same container.

A base image for creating a container with an application using this X11 server container can be found [here](tbd).

My intention for this image was to have a clear separation of concerns. This image is responsible for all the X-Server stuff. Another image can fully concentrate on the application and is simply linked to a container of this image.

More details can be found [here](https://github.com/suchja/x11server/blob/master/Story.md).

## Usage

Running a container based on this image is quite easy. It is intended to be run as daemon. So you can run via:

`docker run -d --name display -e VNC_PASSWORD=newPW -e XFB_SCREEN=1280x800x24 -p 5900:5900 suchja/x11server`

You should give it a name (here `display`), because a container running the client should be linked with this container. Forwarding the port `5900` allows you to access the VNC server from within your network.

### Environment Variables
When you start the `x11server` image, you should adjust at least some of its configuration.

Hint: In case you don't like to type the environment variables on the command prompt, docker run can also read it from a config file (see [here](https://docs.docker.com/reference/commandline/cli/#examples_8)). Especially for passwords (see below) this this should be done to prevent any issues with your shell history (see [here](http://linuxcommando.blogspot.de/2014/07/hide-command-from-bash-command-line.html)).

`VNC_PASSWORD`

This variable is mandatory and specifies the password you need to enter into your VNC-client when connecting to the VNC-Server running in a container from this image.

`XFB_SCREEN`

Specifies screen width, height, and depth (WxHxD). By default, screen has the dimensions 1024x768x24.

### docker-compose
You can use `docker-compose` to avoid typing or copy-and-pasting all the stuff again and again on the command line. Here an excerpt from a `docker-compose.yml` file starting a container from this image:

```
xserver:
	image: suchja/x11server
	ports:
		- 5900:5900
	environment:
		VNC_PASSWORD: yourPW
		XFB_SCREEN: 1280x800x24
```

Save this inside `docker-compose.yml`, add a proper password and call `docker-compose up`. Now you will have a running X11 server waiting for X11 clients and VNC clients to connect.

## Maintenance
The image is build on Docker hub with [Automated builds](http://docs.docker.com/docker-hub/builds/). There is no dedicated maintenance schedule for this image. It is relying on packages from `debian:jessie` and thus I do not assume to update it frequently.

In case you have any issues, you are invited to create a pull request or an issue on the related [github repository](https://github.com/suchja/x11server.git).

## Copyright free
The sources in [this](https://github.com/suchja/x11server.git) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
