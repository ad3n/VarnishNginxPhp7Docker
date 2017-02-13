FROM ubuntu:latest
MAINTAINER Muhammad Surya Ihsanuddin<surya.kejawen@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install Software
RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx-full varnish supervisor vim -y
RUN apt-get install software-properties-common python-software-properties -y
RUN apt-get install curl ca-certificates -y
RUN touch /etc/apt/sources.list.d/ondrej-php.list
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list.d/ondrej-php.list
RUN echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list.d/ondrej-php.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update
RUN apt-get install php7.1 php7.1-cli php7.1-curl php7.1-intl php7.1-mbstring php7.1-xml php7.1-zip \
    php7.1-bcmath php7.1-cli php7.1-fpm php7.1-imap php7.1-json php7.1-mcrypt php7.1-opcache php7.1-xmlrpc \
    php7.1-bz2 php7.1-common php7.1-gd php7.1-ldap php7.1-mysql php7.1-readline php7.1-soap php7.1-tidy php7.1-xsl -y
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get remove --purge -y software-properties-common python-software-properties && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

# Setup Environment
ENV VARNISH_CONFIG  /etc/varnish/default.vcl
ENV CACHE_SIZE      128m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600
ENV VARNISH_PORT    6081
ENV BACKEND_HOST    localhost
ENV BACKEND_PORT    80
ENV VARNISH_SERVER  VARNISH_HTTP_ACCELERATOR
ENV NGINX_WEBROOT   /var/www/html

# Supervisor Configuration
ADD supervisor/supervisor.conf /etc/supervisord.conf

# Varnish Configuration
ADD varnish/default.vcl /etc/varnish/default.vcl

# Nginx Configuration
ADD nginx/sites-enabled/site.conf /etc/nginx/conf.d/default.conf
ADD nginx/sites-enabled/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/fastcgi_cache /etc/nginx/fastcgi_cache
ADD nginx/static_files.conf /etc/nginx/static_files.conf
ADD nginx/logs/site.access.log /var/log/nginx/site.access.log
ADD nginx/logs/site.error.log /var/log/nginx/site.error.log
ADD nginx/etc/sysctl.conf /etc/sysctl.conf
ADD nginx/etc/security/limits.conf /etc/security/limits.conf

RUN chmod 777 /var/log/nginx/site.access.log
RUN chmod 777 /var/log/nginx/site.error.log

# PHP Configuration
ADD php/php.ini /etc/php/7.1/fpm/php.ini
ADD php/php.ini /etc/php/7.1/cli/php.ini
ADD php/php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf
RUN mkdir /run/php
RUN touch /run/php/php7.1-fpm.sock
RUN chmod 777 /run/php/php7.1-fpm.sock

# Here we go
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080 443 80 8888 9000

CMD ["/start.sh"]