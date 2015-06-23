# [RequestBin](http://requestb.in)
## A Runscope community project.

Originally Created by [Jeff Lindsay](http://progrium.com)

This version forked from https://github.com/Runscope/requestbin

License
-------
MIT


Looking to self-host?
=====================

## Deploy your own local instance

```
$ mkdir ~/Envs
$ cd ~/Envs
$ virtualenv requestbin
$ source ~/Envs/requestbin/bin/activate
$ cd ~/src
$ git clone git://github.com/richdawe/requestbin.git
$ sudo apt-get install libevent-dev
$ pip install -r requirements.txt
$ python web.py
```

Browse to http://127.0.0.1:4000/ , and create a bin.
Then post to it using a simple curl command like
(where "tuxozftu" is the randomly-generated bin name):

`$ curl -X POST -d '{}' http://127.0.0.1:4000/tuxozftu`

Then browse to a URL like http://127.0.0.1:4000/tuxozftu?inspect
to see your data.

The requests will be stored in memory. This means your bins
and requests will be lost, when the RequestBin service is restarted.

## Use Redis to store requests for your local instance

See the previous section, and then:


```
# Exit web.py with Ctrl+C then:
$ sudo apt-get install redis-server redis-tools
$ export REQUESTBIN_STORAGE=requestbin.storage.redis.RedisStorage
$ python web.py
```

## Deploy your own instance using Heroku
Create a Heroku account if you haven't, then grab the RequestBin source using git:

`$ git clone git://github.com/richdawe/requestbin.git`

From the project directory, create a Heroku application:

`$ heroku create`

Add Heroku's addon for redistogo

`$ heroku addons:add redistogo:nano --app {app_name}`

Find your redistogo connection details

`$ heroku config --app {app_name} | grep REDISTOGO_URL`

The redistogo URL should be picked up automatically.
If not, modify line 19 of config/heroku.conf.py on redis details

`redis_url = urlparse.urlparse(os.environ.get("REDIS_URL", "redis://REDISTOGO_URL:REDISTOGO_PORT/0"))`

Now just deploy via git:

`$ git push heroku master`

It will push to Heroku and give you a URL that your own private RequestBin will be running.


## Running under Docker

```
$ sudo docker build -t requestbin --rm=true .
$ sudo docker run -d -P requestbin
```

Look at the output of "docker ps" to see public-facing port (e.g.: 49153 below):

```
rdawe@phoenix:~/src/requestbin$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                     NAMES
7d8b937e41b7        requestbin:latest   gunicorn --chdir /va   1 seconds ago       Up 1 seconds        0.0.0.0:49153->8000/tcp   pensive_blackwell
```

TODO:

 * How to automatically expose on public port 8000?
 * How to hook up to a Redis container?

Contributors
------------
 * Barry Carlyon <barry@barrycarlyon.co.uk>
 * Jeff Lindsay <progrium@gmail.com>
