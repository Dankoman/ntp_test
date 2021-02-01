#!/bin/bash
#kaka

SERVER="192.36.143.130"
OUT="/tmp/timediff1.csv"

get_ntp_time () {
    printf "$(date +%Y-%m-%d), $(date +%T:%N), " >> $OUT
    ntpdate -q $SERVER | grep -v "^server " | awk -F " " '{ print $1,$2" 2021,",$3",",$8",",$10 }'
}

log_to_file () {
    if [ ! -f "$OUT" ]; then
        #echo "$OUT does not exist."
        touch $OUT
        echo "Local Date, Local Timestamp, NTP-date, NTP-time, server, offset" > $OUT
        get_ntp_time >> $OUT
    else
        #echo "$OUT exists."
        get_ntp_time >> $OUT    
    fi
}

while true; do log_to_file; sleep 2; done
