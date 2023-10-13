docker run --rm -ti \
    --ulimit core=1073741824 \
    --name my_public_server \
    -p 27015:27015/udp \
    -p 27015:27015/tcp \
    hlds:amxmodx \
    ./hlds_run \
        -debug \
        -game cstrike \
        -strictportbind \
        -ip 0.0.0.0 \
        -port 27015 \
        -maxplayers 10 \
        +sv_lan 0 \
        +map de_dust2
