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
        libarchive-tools=3.4.3-2+deb11u1 \
        gdb=10.1-1.7

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

ARG REHLDS=none
ARG REGAMEDLL=none
ARG METAMOD=none
ARG AMXMODX=none

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
		InstallApp.sh \
		InstallAddons.sh \
		Steam \
		steamcmd

WORKDIR ${STEAMAPPDIR}

# Default command when there are no arguments
CMD [ \
		"./hlds_run", \
		"-game cstrike", \
		"-ip 0.0.0.0", \
		"-port 27015", \
		"-strictportbind", \
		"+sv_lan 0", \
		"+map de_dust2", \
		"-maxplayers 10" \
	]