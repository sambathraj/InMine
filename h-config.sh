#!/usr/bin/env bash

# HiveOS provides these in Custom Miner FS:
# CUSTOM_URL, CUSTOM_USER, CUSTOM_PASS, CUSTOM_USER_CONFIG, WORKER_NAME
# Also wallet vars may exist: EWAL / DWAL / ZWAL

# Where to write generated args for h-run.sh to consume
: "${CUSTOM_CONFIG_FILENAME:=config.ini}"

# Build wallet.worker template
WALLET="${CUSTOM_USER:-${EWAL:-${DWAL:-${ZWAL:-}}}}"
[[ -z "$WALLET" ]] && echo "No wallet set (CUSTOM_USER/EWAL/DWAL/ZWAL)" && return 1

WORKER="${WORKER_NAME:-worker}"
USER_TPL="${WALLET}.${WORKER}"

[[ -z "$CUSTOM_URL" ]] && echo "CUSTOM_URL is empty (set Pool URL in Flight Sheet)" && return 1
PASS="${CUSTOM_PASS:-x}"

# Build miner args (written as a single line)
# NOTE: adjust flags here if iniminer uses different CLI.
conf="-o ${CUSTOM_URL} -u ${USER_TPL} -p ${PASS} ${CUSTOM_USER_CONFIG} --cuda --retry-delay 5 --farm-retries 99"

echo "${conf}" > "${CUSTOM_CONFIG_FILENAME}"
