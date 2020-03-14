image_name="sbuggay/srcds-docker"
image_url="https://github.com/sbuggay/srcds-docker.git"
port=27015
glst_token=""
workshop_token=""
rcon_password=$(< /dev/urandom tr -dc a-z0-9 | head -c${1:-8};echo;)

checkfor () {
        command -v $1 >/dev/null 2>&1 || { 
                echo >&2 "$1 is required"; 
                exit 1; 
        }
}

checkfor "docker"

if ! docker images $image_name | grep -q $image_name; then
        docker build -t $image_name $image_url
fi

docker_id=$(docker run \
                -p $port:$port -p $port:$port/udp \
                -l port=$port -l glst_token=$glst_token -l rcon_password=$rcon_password \
                -d $image_name \
                -port $port +sv_setsteamaccount $glst_token +rcon_password $rcon_password -usercon)

echo -e "$image_name server started"
echo -e "port\t\trcon"
echo -e "$port\t\t$rcon_password"
echo -e "$docker_id"