#Dockerizing X11 Applications - A multi-container approach

##What's the probelm?
Trying to run an application inside a container which requires the X Window system is not really difficult, but also not as easy as it seems. There are several ways of dealing with this:

- Using the host's X Server via shared X11 sockets. Here is a really good [article](https://blog.jessfraz.com/posts/docker-containers-on-the-desktop.html) showing different options.
- Forwarding the display via ssh -X. An approach used by several images and described in [this](http://blog.docker.com/2013/07/docker-desktop-your-desktop-over-ssh-running-inside-of-a-docker-container/) article.
- Run a VNC server along with the X server. Also for this solution several images exist. One example can be found [here](https://docs.docker.com/reference/builder/#dockerfile-examples)

The solution I'm looking for shall be completely host independent so you can deploy it everywhere. This also means that for me seeing the output on the X11 server is usually only required for debugging purposes. 

Now my problem to solve is how to use [Wine](https://www.winehq.org) and [WiX toolset](http://wixtoolset.org) for building MSI-files (Microsoft Windows installer) inside a container. Usually it is a workflow which does not require any user interaction and thus displaying something on an X Window is not required. However, one of the first problems for me was to properly setup the complete environment. During this process I often needed to have a look into the output of wine or the applications running within.

So that basically means I need to run the X11 server the whole time to ensure wine and its applications stop complaining about the missing window system. From time to time I need to have a look into the output from wine, but only if it does not work as expected. Finally I would like to run my solution anywhere and be inline with docker's best practices (e.g. avoid runing an sshd inside a container).

Thus I'll go the VNC path, but ensure that the X11 server is running even if no client is connected to the VNC server.

My first approach was to put everything (source code for building MSI files, WiX toolset, Wine, X11 server, VNC server, ...) inside a single docker image. This resulted in a very large and unhandy image. Rebuilding the complete image or adding a new package tooke quite some time, because around 200 packages needed to be downloaded and installed.

##SRP to the rescue
Why not applying well known and good software development principles to the process of setting up docker images? So I decided to have some more docker images and following the single responsibility principle. This seems to me the docker way anyway.

So the solution comprises the following docker images:

- [suchja/x11server] - This image runs X11 server and VNC server. It provides a magic cookie for an X11 client to connect to the server and requires the user to set a password for the VNC connection. Additionally it is possible to configure some parameters of the X11 server via environment variables. In the future I'll have a look into further securing the access to this image.
- [suchja/x11client] - Uses the magic cookie from X11 server to prepare for an authenticated connection to it. It is intended as a base image for an application requiring X11 access. 
- [suchja/wine] - My sample application to verify that the X11 acess works as expected. It is derived `FROM suchja/x11client`. Additionally it also uses an entrypoint script to use wine as the command which is always run when the container is started.
- [suchja/x11tools] - Even though not required for my initial application, it might be a good idea to get some screenshots or maybe even videos from the running X11 server. Thus this image could provide some additional tools for accessing the X11 server.

##Keep it easy with docker-compose
One of the problems with using several containers is that you need to start and properly link them. Remembering long commands and typing them again is not that nice. Therefore `docker-compose` can help you.

Setting up my environment with wine requires the following `docker-compose.yml`:

```
X11server:
	image: suchja/x11server
	ports:
		- 5900:5900
	environment:
		VNC_PASSWORD: yourPW

X11App:
	image: suchja/wine
	links:
		- X11Server:xserver
	volumes_from:
		- X11Server
```


##Experience and other use cases
After several experiments, I'm now satisfied with the solution. The `x11server` and `x11client` images are really flexible and dedicated to mainly one responsibility. I can also choose whether to start the server at all. When running the x11 application (e.g. my `wine` container) on a hosting plattform, I can do so without running the `x11server` and thus save resources (although the application might give some warnings about the missing X11 server).

I admit that my problem with building MSI files inside a container might be very specific. Thus this is likely not that interessting for you. However, there are a lot of use cases in the area of building software and especially automated testing of software, where you might require an X11 system without actually looking at it. Here I hope the images will help you running this inside containers.