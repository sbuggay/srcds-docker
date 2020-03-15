for i in "$@"; do
        case $i in
        -p=* | --port=*)
                PORT="${i#*=}"
                ;;
        -t=* | --token=*)
                TOKEN="${i#*=}"
                ;;
        --password)
                PASSWORD="${i#*=}"
                ;;
        --rconpassword)
                RCON="${i#*=}"
                ;;
        --workshop)
                WORKSHOP="${i#*=}"
                ;;
        *)
                # unknown option
                ;;
        esac
done

randomPass() {
        tr </dev/urandom -dc a-z0-9 | head -c${1:-8}
        echo
}

# Set defaults

PORT="${PORT:-27015}"
RCON="${RCON:-$(randomPass)}"

IMAGE_NAME="sbuggay/srcds-docker"
IMAGE_URL="https://github.com/sbuggay/srcds-docker.git"

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
echo -e "port\t\trcon\t\t"
echo -e "$PORT\t\t$RCON"
echo -e "$DOCKER_ID"
