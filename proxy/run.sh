#!/bin/sh

set -e

# Inserting the tpl file created inside the container
# Inserts the values from uwsgi_params into the brackets of the default.confi.tpl file
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;' # Running in front (it is possible to see the logs)