#!/usr/bin/env bash
# Minimal stats: iniminer doesn't expose a Hive-style API (as far as we know)

khs=0

pid=$(pidof iniminer-cuda-linux-x64 | awk '{print $1}')
uptime=0
if [[ -n "$pid" ]]; then
  uptime=$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')
  uptime=${uptime:-0}
fi

stats="{\"hs\":[0],\"hs_units\":\"khs\",\"temp\":[],\"fan\":[],\"uptime\":${uptime},\"ver\":\"iniminer-cuda\",\"ar\":[0,0],\"algo\":\"ini\"}"
