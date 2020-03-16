srcds-docker is for easily spinning up 128 tick CS:GO servers with useful plugins and configs installed.

## Prerequisites

- Install Docker https://docs.docker.com/install/

## Using the Install Script

Simply run the `srcds-docker.sh` script.

`curl -s -L https://raw.githubusercontent.com/sbuggay/srcds-docker/master/srcds-docker.sh | bash`

If docker is installed and running, the image will be built for you. This can take ~20 minutes depending on your internet speed.

After the initial run, servers will be spun up nearly instantly.

```
devan@bender:~$ ./srcds-docker.sh
sbuggay/srcds-docker server started
port            rcon
27015           8127tcfo
7c9ba318bd1b9d05c0326ba9d2d0509a6860fc8824dcb063932d99e77cedc7fc
```

# Manual Steps

If you want to change some of the build steps for your image you can do so manually very easily.

## Building the Image

```
docker build -t csgo https://github.com/sbuggay/srcds-docker.git
```

### Plugins

By default the image comes with:

- [metamod](https://www.sourcemm.net/)
- [sourcemod](https://www.sourcemod.net/)
- [splewis/csgo-pug-setup](https://github.com/splewis/csgo-pug-setup) (disabled)
- [splewis/csgo-practice-mode](https://github.com/splewis/csgo-practice-mode) (disabled)
- [EnableDisable.sp](https://forums.alliedmods.net/showthread.php?p=1682844)

If you supply your steam id as a build arg `--build-arg STEAM_ID=<steam_id>`, your steam id will be injected into the sourcemod admin's config at build time.

## Running the Server

```
docker run -d csgo +sv_setsteamaccount <glst_token> +rcon_password <rcon_password>
```

You can run more than one container on the same machine by changing the port that srcds uses and that docker exposes.

```
docker run -d csgo -p 27016:27016 -p 27016:27016/udp -port 27016 +sv_setsteamaccount <glst_token> +rcon_password <rcon_password> 
```

If you need to do any maintainance, you can open a shell in your container with:

```
docker exec -it <container> /bin/bash
```

## Updating the Server

All you need to do is restart the container and srcds will autoupdate automatically.

```
docker restart <container>
```
