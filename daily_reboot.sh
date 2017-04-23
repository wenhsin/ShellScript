
function restartRfidd()
{
    while read line
    do
        #echo $line
        pid=$(echo $line | awk '{print $1}')
        process=$(echo $line | awk '{print $2}')
        
        #echo $pid 
        #echo $process
        if [ "$process" == '/root/rfid_daemon/rfidd' ]; then
            echo kill $pid
            kill -9 $pid
        fi;
    done
    cd /root/rfid_daemon
    /root/rfid_daemon/rfidd
}

ps aux | grep rfidd | awk '{print $2 " " $11}' | restartRfidd
