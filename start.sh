docker run --rm -ti \
    --ulimit core=1073741824 \
    --name my_public_server \
    -p 27016:27016/udp \
    hlds \
        -debug \
        -game cstrike \
        -port 27016 \
        -maxplayers 10 \
        +map de_dust2
