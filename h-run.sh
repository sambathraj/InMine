#!/usr/bin/env bash
cd "$(dirname "$0")"

: "${CUSTOM_CONFIG_FILENAME:=config.ini}"

# Generate config if missing
[ ! -f "${CUSTOM_CONFIG_FILENAME}" ] && . ./h-config.sh || true

chmod +x ./iniminer-cuda-linux-x64

./iniminer-cuda-linux-x64 $(< "${CUSTOM_CONFIG_FILENAME}") 2>&1 | tee /var/log/miner/custom/iniminer-cuda.log
