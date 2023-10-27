FROM debian:bookworm-slim AS build_stage

# Install, update & upgrade packages
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        lib32z1 \
        libarchive-tools curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENV STEAMAPPID  90
ENV STEAMAPPDIR "/root/hlds-cstrike"

ENV DepotDownloader_URL=https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.5.0/DepotDownloader-linux-x64.zip

RUN curl -sSL ${DepotDownloader_URL} | bsdtar -xf - ;\
    chmod +x DepotDownloader &&\
    \
    # Base Goldsrc Shared Content
    ./DepotDownloader -app ${STEAMAPPID} -depot 1    -dir ${STEAMAPPDIR} &&\
    # Linux dedicated server
    ./DepotDownloader -app ${STEAMAPPID} -depot 4    -dir ${STEAMAPPDIR} &&\
    # Counter-Strike Base Content
    ./DepotDownloader -app ${STEAMAPPID} -depot 11   -dir ${STEAMAPPDIR} &&\
    # Steamworks SDK Redist (LINUX32)
    ./DepotDownloader -app ${STEAMAPPID} -depot 1006 -dir ${STEAMAPPDIR}

# Make steamclient.so link
RUN mkdir -p ~/.steam/sdk32/ &&\
    ln -s ${STEAMAPPDIR}/steamclient.so ~/.steam/sdk32/steamclient.so &&\
    ln -s ${STEAMAPPDIR}/steamclient.so ${STEAMAPPDIR}/steamservice.so

RUN cd ${STEAMAPPDIR} \
    && du -ahd1 \
    && ls -l

COPY --chmod=755 \
    etc/InstallAddons.sh \
    ./

ARG REHLDS=latest
ARG REGAMEDLL=latest
ARG METAMOD=latest
ARG AMXMODX=latest

# RUN ./InstallAddons.sh \
#     ${REHLDS} \
#     ${REGAMEDLL} \
#     ${METAMOD} \
#     ${AMXMODX}

# Cleanup
# RUN rm -rf \
# 	InstallApp.sh InstallAddons.sh \
# 	Steam steamcmd .steam/sdk64 && \
# 	find ~/ \
# 	\( \
# 		-name '*64.so' -o \
# 		-name '*64' -o \
# 		-name '*.dll' -o \
# 		-name '*.dylib' \
# 	\) -exec rm -rf {} \;

WORKDIR ${STEAMAPPDIR}

ENTRYPOINT ["./hlds_run"]
CMD [ "-game cstrike -debug +ip 0.0.0.0 -port 27016 -maxplayers 10 +map de_dust2" ]