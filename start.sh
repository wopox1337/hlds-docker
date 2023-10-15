    # --cpus=0.05 \
docker run -ti \
    --ulimit core=1073741824 \
    --name my_public_server \
    -p 27016:27016/udp \
    --restart unless-stopped \
    hlds \
        -debug \
        -game cstrike \
        +map cs_assault \
        -bots \
        -host-improv \
        -port 27016 \
        -maxplayers 32 

