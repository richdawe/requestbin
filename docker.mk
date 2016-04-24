SRCDIR := $(shell pwd)

SUDO = sudo
DOCKER = $(SUDO) docker

default:	build

.PHONY:	build
build:	.build.stamp .build.proxy.stamp

# XXX: Is this necessary, or will docker use the cache?
.build.stamp:	Dockerfile
	$(DOCKER) build -t requestbin-app .
	touch $@

# XXX: Is this necessary, or will docker use the cache?
.build.proxy.stamp:	nginx/Dockerfile nginx/requestbin.conf
	./generate-certs
	$(DOCKER) build -t requestbin-proxy nginx
	touch $@

# Use Redis as the database backend for RequestBin.
# Proxy requests through NGINX, so we can add some authentication
# for creating and viewing bins.
#
# NGINX images: https://github.com/nginxinc/docker-nginx
# Redis images: https://registry.hub.docker.com/u/library/redis/
.PHONY:	run
run:	build
	$(DOCKER) run --name requestbin-redis \
		-d redis:2.8 \
		redis-server --appendonly yes
	$(DOCKER) run --name requestbin-app \
		-d --link requestbin-redis:db \
		-e REQUESTBIN_REDIS_HOST=db \
		-e REQUESTBIN_STORAGE=requestbin.storage.redis.RedisStorage \
		requestbin-app
	$(DOCKER) run --name requestbin-proxy \
		-d -p 8000:80 -p 8443:443 --link requestbin-app:app \
		requestbin-proxy

.PHONY:	stop
stop:
	$(DOCKER) stop requestbin-proxy
	$(DOCKER) stop requestbin-app
	$(DOCKER) stop requestbin-redis
	$(DOCKER) rm requestbin-proxy
	$(DOCKER) rm requestbin-app
	$(DOCKER) rm requestbin-redis

.PHONY:	start
start:	run

.PHONY:	restart
restart:	stop start

.PHONY:	clean
clean:
	rm -f .build.stamp
	rm -f .build.proxy.stamp
