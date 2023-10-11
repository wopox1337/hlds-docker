docker run --rm -ti \
    --name my_public_server \
    -p 27017:27017/udp \
    -p 27017:27017/tcp \
    hlds \
    ./hlds_run \
        -game cstrike \
        -strictportbind \
        -ip 0.0.0.0 \
        -port 27017 \
        +sv_lan 0 \
        +map de_dust2 \
        -maxplayers 10