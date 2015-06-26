FROM REGISTRY/FROM_IMAGE:VERSION
MAINTAINER Artem Golub <artemgolub@gmail.com>

ENTRYPOINT cp /app/config/nginx.conf /etc/nginx/nginx.conf && \
    ln -s /app/config/frontend.conf /etc/nginx/sites-enabled/ && \
    rm /etc/nginx/sites-enabled/default && \
    /usr/sbin/nginx -c /etc/nginx/nginx.conf
