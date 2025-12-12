#!/usr/bin/env bash
. ./h-manifest.conf

# Flight Sheet (Custom Miner) provides these:
# CUSTOM_URL          -> pool host:port (recommended) OR full stratum url
# CUSTOM_USER         -> your wallet (0x...)
# CUSTOM_PASS         -> optional (not used by iniminer in your working cmd, but we keep it for compatibility)
# CUSTOM_USER_CONFIG  -> extra args
# WORKER_NAME         -> rig worker name

WALLET="${CUSTOM_USER}"
WORKER="${WORKER_NAME:-Worker001}"

[[ -z "$WALLET" ]] && echo "ERROR: CUSTOM_USER (wallet) is empty" && exit 1
[[ -z "$CUSTOM_URL" ]] && echo "ERROR: CUSTOM_URL (pool) is empty" && exit 1

# Allow CUSTOM_URL to be either:
#  - pool-a.yatespool.com:31556
#  - stratum+tcp://pool-a.yatespool.com:31556
#  - stratum+tcp://WALLET.WORKER@pool-a.yatespool.com:31556  (if user already included it)
URL="$CUSTOM_URL"
URL="${URL#stratum+tcp://}"

# If user already included "@", assume it already has wallet.worker@
if [[ "$URL" == *@* ]]; then
  POOL="stratum+tcp://$URL"
else
  POOL="stratum+tcp://${WALLET}.${WORKER}@${URL}"
fi

EXTRA="${CUSTOM_USER_CONFIG}"

conf="--pool ${POOL} --cuda --retry-delay 5 --farm-retries 99 ${EXTRA}"

echo "$conf" > "${CUSTOM_CONFIG_FILENAME}"
