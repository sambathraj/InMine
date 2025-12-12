#!/usr/bin/env bash
# Minimal stats output for HiveOS (no miner API available)

uptime=0
if pidof iniminer-cuda-linux-x64 >/dev/null; then
  # get elapsed seconds of first PID
  pid=$(pidof iniminer-cuda-linux-x64 | awk '{print $1}')
  etimes=$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')
  uptime=${etimes:-0}
fi

# Output JSON (HiveOS reads this)
echo "{\"hs\":[0],\"hs_units\":\"hs\",\"temp\":[],\"fan\":[],\"uptime\":${uptime},\"ar\":[0,0],\"ver\":\"iniminer-cuda\"}"
