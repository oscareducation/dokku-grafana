# Dokku grafana

Install grafana as a dokku plugin.

We use our main dokku app as an auth proxy for Grafana, so we don't need to expose Grafana's port to the outisde world.

## Configuration files

Your configuration files for Grafana (`grafana.in` and datasources) should live in the directory given by `grafana:info <name> --config-dir`. Don't forget to restart the service afterwards !

## Requirements

- dokku 0.8.1+
- docker 1.8.x

## Installation

```shell
# on 0.4.x+
sudo dokku plugin:install https://github.com/lazyatom/dokku-chrome.git chrome
```

## Commands

```
grafana:app-links <app>          List all grafana service links for a given app
grafana:create <name>            Create a grafana service with environment variables
grafana:destroy <name>           Delete the service, delete the data and stop its container if there are no links left
grafana:enter <name> [command]   Enter or run a command in a running grafana service container
grafana:exists <service>         Check if the grafana service exists
grafana:expose <name> [port]     Expose a grafana service on custom port if provided (random port otherwise)
grafana:info <name>              Print the connection information
grafana:link <name> <app>        Link the grafana service to the app
grafana:linked <name> <app>      Check if the grafana service is linked to an app
grafana:list                     List all grafana services
grafana:logs <name> [-t]         Print the most recent log(s) for this service
grafana:promote <name> <app>     Promote service <name> as grafana_URL in <app>
grafana:restart <name>           Graceful shutdown and restart of the grafana service container
grafana:start <name>             Start a previously stopped grafana service
grafana:stop <name>              Stop a running grafana service
grafana:unexpose <name>          Unexpose a previously exposed grafana service
grafana:unlink <name> <app>      Unlink the grafana service from the app
grafana:upgrade <name>           Upgrade service <service> to the specified version
```

## Rsage

```shell
# Create a chrome service named lolipop
dokku grafana:create lolipop

# You can also specify the image and image
# version to use for the service
# it *must* be compatible with the
# official browserless/chrome image
export GRAFANA_IMAGE="browserless/chrome"
export GRAFANA_IMAGE_VERSION="1.6.2"
dokku grafana:create lolipop

# You can also specify custom environment
# variables to start the chrome service
# in semi-colon separated form
export GRAFANA_CUSTOM_ENV="MAX_CONCURRENT_SESSIONS=10"
dokku grafana:create lolipop

# Get connection information as follows
dokku grafana:info lolipop

# You can also retrieve a specific piece of service info via flags
dokku grafana:info lolipop --config-dir
dokku grafana:info lolipop --data-dir
dokku grafana:info lolipop --dsn
dokku grafana:info lolipop --exposed-ports
dokku grafana:info lolipop --id
dokku grafana:info lolipop --internal-ip
dokku grafana:info lolipop --links
dokku grafana:info lolipop --service-root
dokku grafana:info lolipop --status
dokku grafana:info lolipop --version

# A bash prompt can be opened against a running service
# filesystem changes will not be saved to disk
dokku grafana:enter lolipop

# You may also run a command directly against the service
# filesystem changes will not be saved to disk
dokku grafana:enter lolipop ls -lah /

# A chrome service can be linked to a
# container this will use native docker
# links via the docker-options plugin
# here we link it to our 'playground' app
# NOTE: this will restart your app
dokku grafana:link lolipop playground

# The following environment variables will be set automatically by docker (not
# on the app itself, so they won’t be listed when calling dokku config)
#
#   DOKKU_GRAFANA_LOLIPOP_NAME=/random_name/CHROME
#   DOKKU_GRAFANA_LOLIPOP_PORT=tcp://172.17.0.1:3000
#   DOKKU_GRAFANA_LOLIPOP_PORT_3000_TCP=tcp://172.17.0.1:3000
#   DOKKU_GRAFANA_LOLIPOP_PORT_3000_TCP_PROTO=tcp
#   DOKKU_GRAFANA_LOLIPOP_PORT_3000_TCP_PORT=3000
#   DOKKU_GRAFANA_LOLIPOP_PORT_3000_TCP_ADDR=172.17.0.1
#
# and the following will be set on the linked application by default
#
#   GRAFANA_URL=http://dokku-chrome-lolipop:3000
#
# NOTE: the host exposed here only works internally in docker containers. If
# you want your container to be reachable from outside, you should use `expose`.

# Another service can be linked to your app
dokku grafana:link other_service playground

# Since GRAFANA_URL is already in use, another environment variable will be
# generated automatically
#
#   DOKKU_GRAFANA_BLUE_URL=http://dokku-chrome-other-service:3000

# You can then promote the new service to be the primary one
# NOTE: this will restart your app
dokku grafana:promote other_service playground

# This will replace GRAFANA_URL with the url from other_service and generate
# another environment variable to hold the previous value if necessary.
# you could end up with the following for example:
#
#   GRAFANA_URL=http://dokku-chrome-other-service:3000
#   DOKKU_GRAFANA_BLUE_URL=http://dokku-chrome-other-service:3000
#   DOKKU_GRAFANA_SILVER_URL=http://dokku-chrome-lolipop:3000

# You can also unlink a chrome service
# NOTE: this will restart your app and unset related environment variables
dokku grafana:unlink lolipop playground

# You can tail logs for a particular service
dokku grafana:logs lolipop
dokku grafana:logs lolipop -t # to tail

# Finally, you can destroy the container
dokku grafana:destroy lolipop
```

## Disabling `docker pull` calls

If you wish to disable the `docker pull` calls that the plugin triggers, you may set the `GRAFANA_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker pull` is disabled.

## Thanks

This plugin was extensively based on the official storage plugins for dokku (e.g. https://github.com/dokku/dokku-postgres) -- thanks to the authors of those plugins for all their hard work!
