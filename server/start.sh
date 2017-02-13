#!/usr/bin/env bash
set -e

for name in BACKEND_PORT BACKEND_HOST VARNISH_SERVER
do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/varnish/default.vcl
done

for name in VARNISH_CONFIG VARNISH_PORT CACHE_SIZE VARNISHD_PARAMS
do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/supervisord.conf
done
for name in NGINX_WEBROOT
do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/nginx/conf.d/default.conf
done

/usr/bin/supervisord -n -c /etc/supervisord.conf
