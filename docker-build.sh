#!/usr/bin/env bash

DIR="$( cd "$(dirname ""$( dirname "${BASH_SOURCE[0]}" )"")" && pwd )"

cd $DIR

# Change this..
PROJECT_NAME='default-app'


MODE=up
PLATFORM=linux
DAEMONIZE=-d
NETWORK_INTERFACE=
HOST_IP=127.0.0.1
FORCE_IP=false
FORCED_HOST_IP=${HOST_IP}
HOST_NAME=${PROJECT_NAME}".localhost"

if [ ! -z "$1" ] && [ "$1" == "down" ]; then
  MODE=$1
elif [ ! -z "$1" ] && [ "$1" == "stop" ]; then
  MODE=$1
elif [ ! -z "$1" ] && [ "$1" == "restart" ]; then
  MODE=$1
fi

for param in "$@" ; do
    case "$param" in
        --ip=*)
            FORCED_HOST_IP="${param#*=}"
            FORCE_IP=true
            ;;
        --no-daemon)
            DAEMONIZE=
            ;;
        --iface=*)
            NETWORK_INTERFACE="${param#*=}"
            ;;
         --help)
            echo "
            --ip=YourIP
            --no-daemon
            --iface=eth0
            "
            exit;
            ;;
    esac
done

if [ `uname` == "Linux" ]; then
    if [ -z "$NETWORK_INTERFACE" ]; then
        NETWORK_INTERFACE="eth0"
    fi

    HOST_IP=$(ifconfig "$NETWORK_INTERFACE" | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

elif [ `uname` == "Darwin" ]; then
    if [ -z "$NETWORK_INTERFACE" ]; then
        NETWORK_INTERFACE="en0"
    fi
    HOST_IP=$(ipconfig getifaddr "$NETWORK_INTERFACE")
    PLATFORM=mac
else
    PLATFORM=windows
fi


if ${FORCE_IP}; then
    HOST_IP=${FORCED_HOST_IP}
fi

export HOST_IP=${HOST_IP};
export VIRTUAL_HOST=${HOST_NAME};
export PROJECT_NAME=${PROJECT_NAME};


if [ "$MODE" == "stop" ] || [ "$MODE" == "restart" ]; then
    docker-compose -f docker-compose.yml stop
fi
if [ "$MODE" == "up" ] || [ "$MODE" == "restart" ]; then
	docker-compose -f docker-compose.yml build
    docker-compose -f docker-compose.yml up ${DAEMONIZE}

    echo "Done!"
    echo "Your IP Address IS: $HOST_IP"
    echo "Your HOST: ${VIRTUAL_HOST}"
fi
if [ "$MODE" == "down" ]; then
    docker-compose -f docker-compose.yml down
fi