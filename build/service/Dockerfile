FROM python:3.6

########################################
# Install nginx
########################################

# Copy paste from the official nginx docker repository

ENV NGINX_VERSION 1.12.0-1~jessie
ENV NJS_VERSION   1.12.0.0.1.10-1~jessie

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 \
    && \
    NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    found=''; \
    for server in \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu \
    ; do \
        echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
        apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
    apt-get remove --purge -y gnupg2 && apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/* \
    && echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
                        nginx=${NGINX_VERSION} \
                        nginx-module-xslt=${NGINX_VERSION} \
                        nginx-module-geoip=${NGINX_VERSION} \
                        nginx-module-image-filter=${NGINX_VERSION} \
                        nginx-module-njs=${NJS_VERSION} \
                        gettext-base \
    && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

########################################
# Install supervisord
########################################

RUN apt-get update && apt-get install -y supervisor \
    && rm -rf /var/lib/apt/lists/*

########################################
# Install gunicorn
########################################

RUN pip install gunicorn

########################################
# Install useful debug utilities
########################################

RUN apt-get update && apt-get install -y vim \
    && rm -rf /var/lib/apt/lists/*

########################################
# Copy service directories
########################################

COPY ./service /service

########################################
# Install application dependencies
########################################

RUN pip install -r /service/requirements.txt

########################################
# Configure services
########################################

# Remove default nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy nginx configuration
COPY ./build/service/nginx.conf /etc/nginx/conf.d/

# Copy supervisord configuration
COPY ./build/service/supervisord.conf /etc/supervisor/conf.d/

# Copy gunicorn configuration
COPY ./build/service/gunicorn.conf /etc/gunicorn/conf.d/

########################################
# Add application files
########################################

WORKDIR /service

ENTRYPOINT exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
