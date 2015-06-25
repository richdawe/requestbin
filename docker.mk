SRCDIR := $(shell pwd)

SUDO = sudo
DOCKER = $(SUDO) docker

default:	build

.PHONY:	build
build:
	$(DOCKER) build -t requestbin-app .

.PHONY:	run
run:
	$(DOCKER) run -d -p 8000:8000 --name=requestbin-app requestbin-app

.PHONY:
stop:
	$(DOCKER) stop requestbin-app
	$(DOCKER) rm requestbin-app

