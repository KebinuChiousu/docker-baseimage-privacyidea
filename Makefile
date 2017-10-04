MAINTAINER=meredithkm
TAG=baseimage-privacyidea
VERSION=0.2

build:
	docker build -t $(MAINTAINER)/$(TAG):$(VERSION) --rm .

tag_latest: 
	docker tag $(MAINTAINER)/$(TAG):$(VERSION) $(MAINTAINER)/$(TAG):latest

release:
	docker push $(MAINTAINER)/$(TAG):$(VERSION)
	docker push $(MAINTAINER)/$(TAG):latest
	@echo "*** Don't forget to create a tag by creating an official GitHub release."

