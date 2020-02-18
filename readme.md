Install Docker https://docs.docker.com/install/


```
docker build -t csgo https://github.com/sbuggay/srcds-docker.git
```


```
docker run -d csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_cache -port 27015 +rcon_password <rcon_password>
```

```
-p 27015:27015 -p 27015:27015/udp
-port 27015
```

```
docker exec -it <container> /bin/bash
```