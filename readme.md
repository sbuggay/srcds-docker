```
docker build -t csgo https://github.com/sbuggay/srcds-docker.git
```


```
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_cache -port 27015 +hostname "test hostname" +rcon_password <rcon_password>
```

```

```