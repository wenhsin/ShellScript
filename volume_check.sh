#!/bin/bash

#variables
DISK_LIST="127.0.0.1:/Logstash_userap1"       #list of partitions to be watched, seperated by "|"
SNDR=$(hostname)@domain.com       #mail sender address
RCPT="TO_EMAIL@domain.com"        #mail receiver address seperated by space
ALERT=80                          #alert when disk usage is over this number of persentage
declare -i ALERT

function checkVolume()
{
        while read line
        do
                usep=$(echo $line | awk '{print $2}' | cut -d'%' -f1)    #get the usage without "%"
                partition=$(echo $line | awk '{print $1}' )    #get the partition name
                mountpoint=`echo $line | awk '{print $3}'`    #get the mount point
                if [[ $usep -ge $ALERT ]]; then
                        echo "Running out of space \"$mountpoint ($usep%)\" on $partition on $(hostname) as on $(date)" | mail -s "[Volume Check] Alert: Almost out of disk space $usep%" -r $SNDR $RCPT
                fi
        done
}

if [[ "$DISK_LIST" != "" ]]; then
        df -H | grep -E ${DISK_LIST} | awk '{print $1 " " $5 " " $6}' | checkVolume
fi

