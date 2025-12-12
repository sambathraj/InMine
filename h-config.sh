#!/usr/bin/env bash

# HiveOS custom miner config for pools that require
# stratum+tcp://wallet.worker@host:port

: "${CUSTOM_CONFIG_FILENAME:=config.ini}"

# CUSTOM_URL already contains wallet.worker@host:port
[[ -z "$CUSTOM_URL" ]] && echo "CUSTOM_URL is empty" && return 1

# Build miner args
# NOTE: do NOT pass -u wallet.worker again
conf="-o ${CUSTOM_URL} --cuda --retry-delay 5 --farm-retries 99"

echo "${conf}" > "${CUSTOM_CONFIG_FILENAME}"
