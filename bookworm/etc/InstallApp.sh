#!/bin/bash

InstallApp() {
	local appdir="$1"
	local appid="$2"
	local targetSize="$3"

	while true; do
		# Download app
		echo -e "\033[1;43m > Start downloading app '${appid}' to dir '${appdir}'\033[0m"

		${STEAMCMDDIR}/steamcmd.sh \
			+force_install_dir "${appdir}" \
			+login anonymous \
			+app_update "${appid}" \
			+quit

		local currentSize=$(du -shm $appdir | cut -f1)
		echo -e " > Current folder size: \033[1;40m${currentSize}MB\033[0m"

		if ((currentSize >= targetSize)); then
			echo -e "\033[1;42m > Application '${appid}' successfully installed to dir '${appdir}' with size: '${currentSize}MB'.\033[0m"
			break
		else
			echo -e "\033[1;41m > Retrying download...\033[0m"
		fi
	done
}

InstallApp "${STEAMAPPDIR}" "${STEAMAPPID}" "500"