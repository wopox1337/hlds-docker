docker run --rm -ti \
    --ulimit core=1073741824 \
    --name my_public_server \
    -p 27017:27015/udp \
    -p 27017:27015/tcp \
    hlds \
    ./hlds_run \
        -debug \
        -game cstrike \
        -strictportbind \
        -ip 0.0.0.0 \
        -port 27017 \
        -maxplayers 10 \
        +sv_lan 0 \
        +map de_dust2
