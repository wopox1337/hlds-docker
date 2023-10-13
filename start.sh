docker run --rm -ti \
    --ulimit core=1073741824 \
    --name my_public_server \
    -p 27016:27016/udp \
    hlds \
    ./hlds_run \
        -debug \
        -game cstrike \
        -strictportbind \
        -ip 0.0.0.0 \
        -port 27016 \
        -maxplayers 10 \
        +sv_lan 0 \
        +map de_dust2
