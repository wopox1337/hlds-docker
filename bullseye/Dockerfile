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

ENV STEAMAPPID  90
ENV STEAMAPP    hlds
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

WORKDIR ${HOMEDIR}

RUN mkdir -p "${STEAMAPPDIR}" && \
	chown -R "${USER}:${USER}" "${STEAMAPPDIR}" \
	# Add entry script
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt"

RUN chown -R "${USER}:${USER}" "${HOMEDIR}/${STEAMAPP}_update.txt"

COPY etc/InstallApp.sh .
RUN chmod +x "${HOMEDIR}/InstallApp.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/InstallApp.sh"

RUN ./InstallApp.sh

ARG REHLDS=none
ARG REGAMEDLL=none
ARG METAMOD=none
ARG AMXMODX=none

COPY etc/InstallAddons.sh .
RUN chmod +x "${HOMEDIR}/InstallAddons.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/InstallAddons.sh"

RUN ./InstallAddons.sh \
	${REHLDS} \
	${REGAMEDLL} \
	${METAMOD} \
	${AMXMODX}

# Switch to user
USER ${USER}

WORKDIR ${STEAMAPPDIR}

# Default command when there are no arguments
CMD [ \
		"./hlds_run", \
		"-game cstrike", \
		"-ip 0.0.0.0", \
		"-port 27017", \
		"-strictportbind", \
		"+sv_lan 0", \
		"+map de_dust2", \
		"-maxplayers 10" \
	]