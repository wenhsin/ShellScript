function restartRfidd()
{
    exist=0
    while read line
    do
        #echo $line
        pid=$(echo $line | awk '{print $1}')
        process=$(echo $line | awk '{print $2}')

        #echo $pid
        #echo $process
        if [ "$process" == '/root/rfid_daemon/rfidd' ]; then
         exist=1   
        fi;
    done
    if [ $exist -eq 0 ]; then       
        echo "RFIDD start" > /dev/kmsg
        cd /root/rfid_daemon
        /root/rfid_daemon/rfidd 
    fi
}

ps aux | grep rfidd | awk '{print $2 " " $11}' | restartRfidd
