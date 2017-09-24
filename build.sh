MAINTAINER=meredithkm
TAG=baseimage-privacyidea
VERSION=0.1
docker build -t $MAINTAINER/$TAG:$VERSION -t $MAINTAINER/$TAG:latest .
docker push $MAINTAINER/$TAG:$VERSION
docker push $MAINTAINER/$TAG:latest

