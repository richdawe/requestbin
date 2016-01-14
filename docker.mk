SRCDIR := $(shell pwd)

SUDO = sudo
DOCKER = $(SUDO) docker

default:	build

.PHONY:	build
build:	.build.stamp

.build.stamp:	Dockerfile
	$(DOCKER) build -t requestbin-app .
	touch $@

# Redis images: https://registry.hub.docker.com/u/library/redis/
.PHONY:	run
run:	build
	$(DOCKER) run --name requestbin-redis \
		-d redis:2.8 \
		redis-server --appendonly yes
	$(DOCKER) run --name requestbin-app \
		-d -p 8000:8000 --link requestbin-redis:redis \
		-e REQUESTBIN_REDIS_HOST=redis \
		-e REQUESTBIN_STORAGE=requestbin.storage.redis.RedisStorage \
		requestbin-app

.PHONY:	stop
stop:
	$(DOCKER) stop requestbin-app
	$(DOCKER) stop requestbin-redis
	$(DOCKER) rm requestbin-app
	$(DOCKER) rm requestbin-redis

.PHONY:	clean
clean:
	rm -f .build.stamp
