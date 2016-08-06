# XXX: Write an equivalent of this using docker compose.
# XXX: Add JSON pretty printing to UI
# XXX: Add support for ignoring requests without a specific header.
# XXX: Allow bins to last forever.

SRCDIR := $(shell pwd)

SUDO = sudo
DOCKER = $(SUDO) docker

default:	build

.PHONY:	build
build:
	$(DOCKER) build -t requestbin-app .
	./generate-certs
	./generate-htpasswd
	$(DOCKER) build -t requestbin-proxy nginx

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
	rm -f haikunator-venv
