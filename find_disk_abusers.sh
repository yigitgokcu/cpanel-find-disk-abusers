#!/bin/bash

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Vars
# ---------------------------------------------------\
DATE=`date +"%Y-%m-%d"`
HOSTNAME=$(hostname)
CHANNEL="channel_name"
WEBHOOK_URL=webhook_url

# Main
# ---------------------------------------------------\
for i in $(whmapi1 --output=pretty get_disk_usage|egrep "user|blocks_used"|sed 'N;s/\n/ /'|sort -nrk2|head -n10|awk '{print "User:" $NF }' | cut -d ':' -f 2) ; do find /home/$i -type f -size +1G -exec ls -lh {} \; | awk '{ print $5 ": " $9 }' | sort -nr >> /path/to/disk_abusers/$DATE-disk_abusers.txt; done

# Payload
# ---------------------------------------------------\
MSG1=$(printf "**Top Disk Abusers on $HOSTNAME** \n\n" && cat /path/to/disk_abusers/$DATE-disk_abusers.txt)
MSG2=$(printf "**There isn't any file larger than 1G on $HOSTNAME but you might want to check anyway.**")
PAYLOAD1="payload={\"channel\": \"$CHANNEL\", \"text\": \":warning: $MSG1\"}"
PAYLOAD2="payload={\"channel\": \"$CHANNEL\", \"text\": \":warning: $MSG2\"}"

# Check if any result exist in txt file and send it to Mattermost  
# ---------------------------------------------------\

if [ -s /path/to/disk_abusers/$DATE-disk_abusers.txt ]
then
     curl -X POST --data-urlencode "$PAYLOAD1" "$WEBHOOK_URL"
else
     curl -X POST --data-urlencode "$PAYLOAD2" "$WEBHOOK_URL"
fi

# Delete .txt files older than 1 month
find /path/to/disk_abusers/ -name "*.txt" -type f -mtime +30 -exec rm -f {} \;
