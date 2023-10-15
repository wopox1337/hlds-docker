###########################################################
# Dockerfile that builds a Counter-Strike 1.6 Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

LABEL maintainer="https://github.com/wopox1337"

# Install, update & upgrade packages
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.21-1+deb11u1 \
		ca-certificates=20210119 \
		lib32z1=1:1.2.11.dfsg-2+deb11u2 \
        libarchive-tools=3.4.3-2+deb11u1

# Clean
RUN rm -rf /var/lib/apt/lists/*

ENV STEAMAPPID  90
ENV STEAMAPP    hlds
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

WORKDIR ${HOMEDIR}

COPY --chmod=755 \
	etc/InstallAddons.sh \
	etc/InstallApp.sh \
	${HOMEDIR}

# Switch to user
USER ${USER}

RUN ./InstallApp.sh

ARG REHLDS=latest
ARG REGAMEDLL=latest
ARG METAMOD=latest
ARG AMXMODX=latest

RUN ./InstallAddons.sh \
	${REHLDS} \
	${REGAMEDLL} \
	${METAMOD} \
	${AMXMODX}

# Copy .steam files
RUN mv \
	${STEAMCMDDIR}/steamservice.so \
	${STEAMCMDDIR}/linux32/steamclient.so \
	~/.steam/sdk32/

# Cleanup
RUN rm -rf \
	InstallApp.sh InstallAddons.sh \
	Steam steamcmd .steam/sdk64


# Clean debian-slim server
FROM debian:12-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates=20230311 \
		libc6-i386=2.36-9+deb12u3 \
		gdb-minimal=13.1-3 \
	&& rm -rf /var/lib/apt/lists/*

# Set environment variables
ARG PUID=1000
ENV USER steam
ENV HOMEDIR "/home/${USER}"

ENV STEAMAPP    hlds
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

# Set working directory
WORKDIR $HOMEDIR

# Create unprivileged user
RUN useradd -u "${PUID}" -m "${USER}"

COPY --from=build_stage /home/steam ${HOMEDIR}

WORKDIR ${STEAMAPPDIR}
USER ${USER}

EXPOSE 27016/udp

ENTRYPOINT ["./hlds_run"]
CMD [ "-game cstrike", "-debug", "+ip 0.0.0.0", "-port 27016" "-maxplayers 10", "+map de_dust2",  ]

# ./hlds_run -game cstrike -debug -maxplayers 10 +map de_dust2 +log on
# docker run --rm -it --cpus=0.1 hlds:amxmodx