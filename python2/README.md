dockerfiles-alt-python2
=======================

ALT dockerfile for python.

Image contains python(2) and tools to get upstream python modules. Main purpose
of the image is to run python apps using upstream modules.

Copy Dockerfile somewhere and build the image:
`$ docker build --rm -t <username>/python2 .`

And launch the python container:
`docker run -it <username>/python2`
