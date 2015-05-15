# [RequestBin](http://requestb.in)
## A Runscope community project.

Originally Created by [Jeff Lindsay](http://progrium.com)

This version forked from https://github.com/Runscope/requestbin

License
-------
MIT


Looking to self-host?
=====================

## Deploy your won local instance

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


Contributors
------------
 * Barry Carlyon <barry@barrycarlyon.co.uk>
 * Jeff Lindsay <progrium@gmail.com>
