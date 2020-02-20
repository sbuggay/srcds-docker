srcds-docker is for easily spinning up 128 tick CS:GO servers with useful plugins and configs installed.

## Prerequisites

- Install Docker https://docs.docker.com/install/

## Building the Image

```
docker build -t csgo https://github.com/sbuggay/srcds-docker.git
```

### Plugins

By default the image comes with:
- [metamod](https://www.sourcemm.net/)
- [sourcemod](https://www.sourcemod.net/)
- [splewis/csgo-pug-setup](https://github.com/splewis/csgo-pug-setup)
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