#!/bin/bash

mkdir -p /var/log/netmonitor/wget

SLEEP=10
HOST=8.8.8.8
PORT=53
URL="https://www.gnu.org/licenses/gpl-3.0.html"

LOGFILE=/var/log/netmonitor/`date +%Y-%m-%d`-netmonitor.log

log(){
   message="$(date +"%y-%m-%d %T") | $@"
   echo $message >>$LOGFILE
}

log "Start check"

while true; do

##Ping check 
PLOSS=101
PLOSS=$(ping -q -w10 $HOST | grep -o "[0-9]*%" | tr -d %) > /dev/null 2>&1
log "Host $HOST packet loss ($PLOSS%)"

##Port check
CHECKPORT=$(nc -w 0 -vn $HOST $PORT 2>&1)
log "$CHECKPORT"

##URL check
WGET=$(wget --timeout=3 --tries=3 $URL -O /var/log/netmonitor/wget/`date +%Y-%m-%d-%T`-test.html 2>&1)
log "($WGET)"

sleep $SLEEP
done;
