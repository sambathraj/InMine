#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"
. ./h-manifest.conf

# Prefer Flight Sheet environment variables.
# If HiveOS didn't export them into the process env, fall back to sourcing /hive-config/*.conf.
need_fallback=0
[[ -z "$CUSTOM_TEMPLATE" ]] && need_fallback=1
[[ -z "$CUSTOM_URL" ]] && need_fallback=1
# CUSTOM_USER_CONFIG can be empty legitimately, so don't require it.

if [[ $need_fallback -eq 1 ]]; then
  for f in /hive-config/*.conf; do
    # Only source files that look like the custom miner config
    if grep -q '^CUSTOM_MINER=' "$f" 2>/dev/null; then
      # shellcheck disable=SC1090
      . "$f"
    fi
  done
fi

# Validate required vars (after fallback)
[[ -z "$CUSTOM_TEMPLATE" ]] && echo "ERROR: wallet is empty (CUSTOM_TEMPLATE)" && exit 1
[[ -z "$CUSTOM_URL" ]] && echo "ERROR: pool is empty (CUSTOM_URL)" && exit 1

WORKER="${WORKER_NAME:-worker001}"

# CUSTOM_URL should be host:port (recommended). If it already includes stratum prefix, strip it.
URL="${CUSTOM_URL#stratum+tcp://}"

# Pool requires: stratum+tcp://wallet.worker@host:port
POOL="stratum+tcp://${CUSTOM_TEMPLATE}@${URL}"

EXTRA="${CUSTOM_USER_CONFIG:-}"

conf="--pool ${POOL} ${EXTRA}"

echo "$conf" > "${CUSTOM_CONFIG_FILENAME}"
