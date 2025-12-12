#!/usr/bin/env bash
cd "$(dirname "$0")"

[ -t 1 ] && . colors
. ./h-manifest.conf

# Generate config on every start
./h-config.sh || exit 1

[[ -z $CUSTOM_LOG_BASENAME ]] && echo -e "${RED}No CUSTOM_LOG_BASENAME is set${NOCOLOR}" && exit 1
[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && exit 1
[[ ! -f $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}Custom config ${YELLOW}$CUSTOM_CONFIG_FILENAME${RED} is not found${NOCOLOR}" && exit 1

CUSTOM_LOG_BASEDIR=$(dirname "$CUSTOM_LOG_BASENAME")
[[ ! -d $CUSTOM_LOG_BASEDIR ]] && mkdir -p "$CUSTOM_LOG_BASEDIR"

chmod +x ./"$CUSTOM_NAME"

# Run miner
./"$CUSTOM_NAME" $(< "$CUSTOM_CONFIG_FILENAME") "$@" 2>&1 | tee "$CUSTOM_LOG_BASENAME".log
