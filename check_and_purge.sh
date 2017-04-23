DISK_PATH="/dev/disk/by-uuid"
THRESHOLD=40
declare -i THRESHOLD
function purge_one()
{
CMD=`/bin/ls -am /var/log/RFIDD*`
array=($CMD)
len=${#array[*]}
TARGET=`echo ${array[0]} | /usr/bin/tr -d ","`
echo "purge target=>$TARGET"
result=`/bin/rm -f $TARGET`
}

function checkVolume()
{
        while read line
        do
                usep=$(echo $line | /usr/bin/awk '{print $2}' | /usr/bin/cut -d'%' -f1)    #get the usage without "%"
                if [[ $usep -ge $THRESHOLD ]]; then
                        echo "Purge the oldest one index..."
                        purge_one
                else
                        echo "normal..."
                fi
        done
}

if [[ "$DISK_PATH" != "" ]]; then
        /bin/df -H | /bin/grep -E ${DISK_PATH} | /usr/bin/awk '{print $1 " " $5 " " $6}' | checkVolume
fi

