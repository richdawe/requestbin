FROM nginx:1.9

RUN mkdir /etc/nginx/ssl
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

COPY requestbin.loc /etc/nginx/conf.d/
COPY requestbin.conf /etc/nginx/conf.d/

