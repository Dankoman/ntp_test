#!/bin/bash
#remote st delay offset jitter
printf 'remote st delay offset jitter\n'
printf '%s %s\n' "$(date)" "$line"; ntpq -p | grep -v "==" |grep -v "remote" | awk -F " " '{ print $1,$3,$8,$9,$10 }'
