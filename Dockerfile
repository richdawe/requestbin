FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
  python \
  python-dev \
  python-pip \
  libevent-dev

COPY requirements.txt /var/tmp/requestbin/
RUN pip install -r /var/tmp/requestbin/requirements.txt
COPY . /var/tmp/requestbin/

EXPOSE 8000

CMD [ "gunicorn", "--chdir", "/var/tmp/requestbin", "--bind", ":8000", "--worker-class", "gevent", "--workers", "2", "--max-requests", "1000", "requestbin:app" ]

