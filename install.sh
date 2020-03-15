#!/bin/bash

PARAMS=""

while (("$#")); do
        case "$1" in
        -p | --port)
                PORT=$2
                shift 2
                ;;
        -t | --token)
                TOKEN=$2
                shift 2
                ;;
        -w | --workshop)
                WORKSHOP=$2
                shift 2
                ;;
        -r | --rcon_password)
                RCON=$2
                shift 2
                ;;
        --) # end argument parsing
                shift
                break
                ;;
        *) # preserve positional arguments
                PARAMS="$PARAMS $1"
                shift
                ;;
        esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

randomPass() {
        tr </dev/urandom -dc a-z0-9 | head -c${1:-8}
        echo
}

# Set defaults

PORT="${PORT:-27015}"
RCON="${RCON:-$(randomPass)}"

IMAGE_NAME="sbuggay/srcds-docker"
IMAGE_URL="https://github.com/sbuggay/srcds-docker.git"

echo $PORT $RCON

checkfor() {
        command -v $1 >/dev/null 2>&1 || {
                echo >&2 "$1 is required"
                exit 1
        }
}

checkfor "docker"

if ! docker images $IMAGE_NAME | grep -q $IMAGE_NAME; then
        docker build -t $IMAGE_NAME $IMAGE_URL
fi

DOCKER_ID=$(docker run \
        -p $PORT:$PORT -p $PORT:$PORT/udp \
        -l port=$PORT -l glst_token=$TOKEN -l rcon_password=$RCON \
        -d $IMAGE_NAME \
        -port $PORT +sv_setsteamaccount $TOKEN +rcon_password $RCON -authkey $WORKSHOP -usercon)

echo -e "$IMAGE_NAME server started"
echo -e "dockerid\t\tport\t\trcon\t\t"
echo -e "${DOCKER_ID:0:8}\t\t$PORT\t\t$RCON"
