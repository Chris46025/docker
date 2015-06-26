FROM REGISTRY/FROM_IMAGE:VERSION
MAINTAINER Artem Golub <artemgolub@gmail.com>

# Update package list, upgrade
# Install python-pip and virtualenv
# Clean up APT when done
RUN apt-get update && \
    apt-get -y -q upgrade && \
    apt-get install --no-install-recommends -q -y \
        python \
        libpq-dev \
        python-dev \
        build-essential \
        python-pip \
        uwsgi-plugin-python \
        git \
        openssh-server \
        openssh-sftp-server \
        nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
