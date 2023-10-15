#!/bin/bash

cd ${STEAMAPPDIR}

REHLDS_TAG=$1
REGAMEDLL_TAG=$2
METAMOD_TAG=$3
AMXMODX_TAG=$4

GetLatestGithubReleaseUrl() {
	local repo=$1
	local tag=$2
	local releaseLink="https://api.github.com/repos/${repo}/releases/tags/$tag"

	
	if [ "$tag" = "none" ]; then
		echo "none"
		return 1
	fi

	if [ "$tag" = "latest" ]; then
		releaseLink="https://api.github.com/repos/${repo}/releases/latest"
	fi

	echo $(curl --silent ${releaseLink} | grep "browser_download_url" | grep -Eo 'https:\/\/[^\"]*\.zip')
}

# Install ReHLDS
rehldsReleaseLink=$(GetLatestGithubReleaseUrl "dreamstalker/rehlds" $REHLDS_TAG)
if [ "$rehldsReleaseLink" != "none" ]; then
	echo -e "\033[1;43m > Starting download ReHLDS ...\033[0m"
	curl -sSL $(GetLatestGithubReleaseUrl "dreamstalker/rehlds" $REHLDS_TAG) | bsdtar -xf - --strip-components=2 --directory "${STEAMAPPDIR}" bin/linux32/*
	chmod +x hlds_run hlds_linux hltv
fi

# Install ReGameDLL
if [ "$REGAMEDLL_TAG" != "none" ]; then
	echo -e "\033[1;43m > Starting download ReGameDLL ...\033[0m"
	curl -sSL $(GetLatestGithubReleaseUrl "s1lentq/ReGameDLL_CS" $REGAMEDLL_TAG) | bsdtar -xf - --strip-components=2 --directory "${STEAMAPPDIR}" bin/linux32/*

	# (`-bots` support) https://github.com/s1lentq/ReGameDLL_CS/blob/b53ebb203794446b6ccb35d0ca975b6eef3de93d/README.md#how-to-install-zbot-for-cs-16
	curl -sSL https://github.com/s1lentq/ReGameDLL_CS/blob/b53ebb203794446b6ccb35d0ca975b6eef3de93d/regamedll/extra/zBot/bot_profiles.zip?raw=true | bsdtar -xf - --directory "${STEAMAPPDIR}"

	# (`-host-improv` support) https://github.com/s1lentq/ReGameDLL_CS/blob/b53ebb203794446b6ccb35d0ca975b6eef3de93d/README.md#how-to-install-cscz-hostage-ai-for-cs-16
	curl -sSL https://github.com/s1lentq/ReGameDLL_CS/blob/b53ebb203794446b6ccb35d0ca975b6eef3de93d/regamedll/extra/HostageImprov/host_improv.zip?raw=true | bsdtar -xf - --directory "${STEAMAPPDIR}"
fi



# Install Metamod-R or Metamod-P 1.21p38
if [ "$METAMOD_TAG" != "none" ]; then
	echo -e "\033[1;43m > Starting download Metamod-R ...\033[0m"
	if [ "$REHLDS_TAG" != "none" ]; then
		metamodLink=$(GetLatestGithubReleaseUrl "theAsmodai/metamod-r" $METAMOD_TAG)
		curl -sSL ${metamodLink} | bsdtar -xf - --directory "${STEAMAPPDIR}/cstrike" --exclude *.dll addons
		sed -i 's/gamedll_linux "dlls\/cs.so"/gamedll_linux "addons\/metamod\/metamod_i386.so"/' ${STEAMAPPDIR}/cstrike/liblist.gam
	else
		metamodLink="https://github.com/Bots-United/metamod-p/releases/download/v1.21p38/metamod_i686_linux_win32-1.21p38.tar.xz"
		mkdir -p ${STEAMAPPDIR}/cstrike/addons/metamod
		curl -sSL ${metamodLink} | bsdtar -xf - --directory "${STEAMAPPDIR}/cstrike/addons/metamod" --exclude *.dll metamod.so
		sed -i 's/gamedll_linux "dlls\/cs.so"/gamedll_linux "addons\/metamod\/metamod.so"/' ${STEAMAPPDIR}/cstrike/liblist.gam
		
		# Because Metamod-P 1.21p38 partially incompatible with ReGameDLL 
		echo "gamedll dlls/cs.so" >> ${STEAMAPPDIR}/cstrike/addons/metamod/config.ini
	fi
fi

ActivateMetamodPlugins() {
	echo -e "\033[1;43m > Activate metamod plugins ...\033[0m"

	cd ${STEAMAPPDIR}/cstrike
	find addons/*/dlls/*.so -exec printf 'linux %s\n' {} \; | grep -v metamod_i386.so > addons/metamod/plugins.ini
}

# AMXX Install
echo -e "\033[1;43m > Starting download AMXModX ...\033[0m"
if [ "$AMXMODX_TAG" != "none" ]; then
	version="1.10"
	git_number="5466"

	# 1.10.0-git5466 
	if [[ $AMXMODX_TAG =~ ([0-9]+\.[0-9]+)\.0-git([0-9]+) ]]; then
		version="${BASH_REMATCH[1]}"
		git_number="${BASH_REMATCH[2]}"
	fi

	amxxLink="http://www.amxmodx.org/amxxdrop/${version}/amxmodx-${version}.0-git${git_number}-base-linux.tar.gz"
	cstrikeLink="http://www.amxmodx.org/amxxdrop/${version}/amxmodx-${version}.0-git${git_number}-cstrike-linux.tar.gz"

	curl -sSL ${amxxLink} | bsdtar -xf - --directory "${STEAMAPPDIR}/cstrike"
	curl -sSL ${cstrikeLink} | bsdtar -xf - --directory "${STEAMAPPDIR}/cstrike"

	ActivateMetamodPlugins
fi
