#!/bin/bash
SCRIPTPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $SCRIPTPATH/containers.sh

build_base

build_dev_base

build_dev_backend

build_dev_webserver
