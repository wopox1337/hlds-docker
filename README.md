# hlds-docker

## How to use this image

### Create `Dockerfile` in your server project
```Dockerfile
# Specify the base image with the desired version:<version>
FROM wopox1337/hlds-cstrike:1.1.2.7

EXPOSE 27016/udp
```

You can then build and run the Docker image:
```Bash
docker build -t my-cstrike-server .
docker run --it --rm --name my-running-cstrike-server my-cstrike-server
```

If you prefer Docker Compose:
```yaml
version: '3'
services:
  cstrike-gameserver:
    image: wopox1337/hlds-cstrike:1.1.2.7
    env_file: .env
    ulimits:
      core:
        soft: 1073741824 # 1GB
        hard: 1073741824 # 1GB
    ports:
      - ${PORT}:${PORT}/udp
    stdin_open: true
    tty: true
    build:
      context: ./bullseye
      args:
        - REHLDS=latest
        - REGAMEDLL=latest
        - METAMOD=latest
        - AMXMODX=1.10.0-git5466
    entrypoint: ./hlds_run
    command: [
        "-debug -game cstrike -ip 0.0.0.0 -port ${PORT} +map ${MAP} -maxplayers ${MAXPLAYERS}"
    ]
```
You can then run using Docker Compose:
```Bash
docker-compose up -d
```


