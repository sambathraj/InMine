#!/usr/bin/env bash

# Replace with your gominer-opencl-nvidia API endpoint
API_URL="http://127.0.0.1:3333"

cd `dirname $0`
#. h-manifest.conf
#. debug.conf
#. /hive-config/wallet.conf
. /hive/custom/$CUSTOM_MINER/h-manifest.conf

#algo_avail=("balloon" "bcd" "bitcore" "c11" "hmq1725" "hsr" "lyra2z" "phi" "polytimos" "renesis" "sha256t" "skunk" "sonoa" "timetravel" "tribus" "x16r" "x16s" "x17" "x22i")

algo="Blake3"

stats_raw=`curl --connect-timeout 2 --max-time 25 --silent --noproxy '*' $API_URL`
#echo $stat_raw
if [[ $? -ne 0 ]]; then
	echo -e "${YELLOW}Failed to read miner stats from localhost:3333${NOCOLOR}"
	stats=""
	khs=0
else
 gpu_worked=`echo $stats_raw | jq '.devices[].index'`
 gpu_busid=(`cat /var/run/hive/gpu-detect.json | jq -r '.[] | select(.brand=="nvidia") | .busid' | cut -d ':' -f 1`)
 busids=''
 idx=0
	for i in $gpu_worked; do
#		gpu=`cat /var/run/hive/gpu-detect.json | jq -r --arg idx "$i" '.[$idx|tonumber].busid' | cut -d ':' -f 1`
		gpu=${gpu_busid[$i]}
		busids[idx]=$((16#$gpu))
		idx=$((idx+1))
	done
	stats=$(jq --argjson gpus "`echo ${busids[@]} | jq -cs .`" \
	--arg algo $algo \
	'{ver: "ByGdd", hs: [.devices[].hashRate / 1000], hs_units: "Khs", temp: [.devices[].temperature], fan: [.devices[].fanPercent], uptime: .uptime, ar: [.validShares, .invalidShares], $algo, bus_numbers: $gpus}' <<< $stats_raw)

	# total hashrate in khs
	khs=$(jq "[.devices[].hashRate] | add / 1000 " <<< $stats_raw)

fi
