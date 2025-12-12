#!/usr/bin/env bash
cd "$(dirname "$0")"

[ -t 1 ] && . colors

# If you have h-manifest.conf, keep sourcing it. If you don't, this is harmless.
[ -f ./h-manifest.conf ] && . ./h-manifest.conf

# Ensure config exists
: "${CUSTOM_CONFIG_FILENAME:=config.ini}"
if [ ! -f "${CUSTOM_CONFIG_FILENAME}" ]; then
  echo "Custom config ${CUSTOM_CONFIG_FILENAME} not found. Running h-config.sh..."
  . ./h-config.sh || exit 1
fi

# Log path (HiveOS often sets CUSTOM_LOG_BASENAME, but we default it)
: "${CUSTOM_LOG_BASENAME:=/var/log/miner/custom/iniminer-cuda}"

mkdir -p "$(dirname "${CUSTOM_LOG_BASENAME}")"

chmod +x ./iniminer-cuda-linux-x64

# Run miner
./iniminer-cuda-linux-x64 $(< "${CUSTOM_CONFIG_FILENAME}") "$@" 2>&1 | tee "${CUSTOM_LOG_BASENAME}.log"
