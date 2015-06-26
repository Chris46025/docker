#!/bin/bash

# set -o xtrace (Show verbose command output for debugging.)
# set +o xtrace (To revert to normal.)

# Define project name.
PROJECTNAME="docker"

SCRIPTPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONFDIR=$SCRIPTPATH
ROOTDIR=`dirname $CONFDIR`

REGISTRY="agolub"

VER_BASE="latest"
VER_DEV_BASE="latest"
VER_DEV_BACKEND="latest"
VER_DEV_WEBSERVER="latest"


#--------------------------------------------------------------------------------#
# Default base image.
#--------------------------------------------------------------------------------#

build_base() {
    NAME=base
    VERSION=$VER_BASE

    sed -i '' 's/:VER_BASE/:'"$VER_BASE"'/g' $CONFDIR/$NAME/Dockerfile
    build $NAME $VERSION
    sed -i '' 's/:'"$VER_BASE"'/:VER_BASE/g' $CONFDIR/$NAME/Dockerfile
}


#--------------------------------------------------------------------------------#
# Development related build scripts.
#--------------------------------------------------------------------------------#

# Project specific base image.
build_dev_base() {
    FROM_IMAGE=base
    NAME=$PROJECTNAME-$FROM_IMAGE
    VERSION=$VER_DEV_BASE

    sed -i '' 's/:VERSION/:'"$VERSION"'/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/REGISTRY/'"$REGISTRY"'/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/FROM_IMAGE/'"$FROM_IMAGE"'/g' $CONFDIR/$NAME/Dockerfile

    build $NAME $VERSION

    sed -i '' 's/:'"$VERSION"'/:VERSION/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/'"$REGISTRY"'/REGISTRY/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/'"$FROM_IMAGE"'/FROM_IMAGE/g' $CONFDIR/$NAME/Dockerfile
}

# Project specific application image.
build_dev_backend() {
    FROM_IMAGE=$PROJECTNAME-base
    NAME=$PROJECTNAME-backend
    VERSION=$VER_DEV_BACKEND

    sed -i '' 's/:VERSION/:'"$VERSION"'/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/REGISTRY/'"$REGISTRY"'/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/FROM_IMAGE/'"$FROM_IMAGE"'/g' $CONFDIR/$NAME/Dockerfile

    build $NAME $VERSION

    sed -i '' 's/:'"$VERSION"'/:VERSION/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/'"$REGISTRY"'/REGISTRY/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/'"$FROM_IMAGE"'/FROM_IMAGE/g' $CONFDIR/$NAME/Dockerfile
}

# Project specific webserver image.
build_dev_webserver() {
    FROM_IMAGE=$PROJECTNAME-base
    NAME=$PROJECTNAME-webserver
    VERSION=$VER_DEV_WEBSERVER

    sed -i '' 's/:VERSION/:'"$VERSION"'/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/REGISTRY/'"$REGISTRY"'/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/FROM_IMAGE/'"$FROM_IMAGE"'/g' $CONFDIR/$NAME/Dockerfile

    build $NAME $VERSION

    sed -i '' 's/:'"$VERSION"'/:VERSION/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/'"$REGISTRY"'/REGISTRY/g' $CONFDIR/$NAME/Dockerfile
    sed -i '' 's/'"$FROM_IMAGE"'/FROM_IMAGE/g' $CONFDIR/$NAME/Dockerfile
}


#--------------------------------------------------------------------------------#
# Development related Docker run scripts.
#--------------------------------------------------------------------------------#

run_base() {
    NAME=base

    docker run \
        -d \
        -h $NAME \
        --name $NAME \
        $REGISTRY/base:$VER_BASE
}

run_postgres() {
    docker run --name $PROJECTNAME-postgres -e POSTGRES_PASSWORD=postgres -d postgres
}

run_dev_backend() {
    NAME=$PROJECTNAME-backend

    ls $ROOTDIR/app

    mkdir -p $ROOTDIR/logs

    docker run \
        --link $PROJECTNAME-postgres:postgres \
        -v $ROOTDIR/app:/app \
        -v $ROOTDIR/logs:/logs \
        -d \
        -h $NAME \
        -p 9000:9000 \
        --name $NAME \
        $REGISTRY/$PROJECTNAME-backend:$VER_DEV_BACKEND
}

run_dev_webserver() {
    NAME=$PROJECTNAME-webserver

    docker run \
        --link $PROJECTNAME-backend:backend \
        --volumes-from $PROJECTNAME-backend \
        --name $NAME \
        -d \
        -p 80:80 \
        $REGISTRY/$PROJECTNAME-webserver:$VER_DEV_WEBSERVER
}


#--------------------------------------------------------------------------------#
# Utilities.
#--------------------------------------------------------------------------------#

build() {
    cd $CONFDIR/$1
    docker build -t $REGISTRY/$1:$2 .
}

stop_remove() {
    # @param $1: name of container to stop and remove
    if [ `docker ps | grep $1 | wc -l` -ne 0 ]; then
        docker stop $1
    fi
    if [ `docker ps -a | grep $1 | wc -l` -ne 0 ]; then
        docker rm $1
    fi
    sleep 2
}
