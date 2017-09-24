MAINTAINER=meredithkm
TAG=baseimage-privacyidea
VERSION=0.1
docker run --rm -t -i $MAINTAINER/$TAG:$VERSION /sbin/my_init -- bash -l
