#!/bin/bash
spawn_executables () {
 ifstat -d 1
 ./APM1 192.168.179.1&
 PID1=$!
 ./APM2 192.168.179.1& 
 PID2=$!
 ./APM3 192.168.179.1&
 PID3=$!
 ./APM4 192.168.179.1& 
 PID4=$!
 ./APM5 192.168.179.1&
 PID5=$! 
 ./APM6 192.168.179.1& 
 PID6=$!
}

collect_process_metrics () {
 echo "$SECONDS,$(ps aux | egrep 'APM1' | head -1 | awk '{print $3","$4}')" >> APM1_metrics.csv
 echo "$SECONDS,$(ps aux | egrep 'APM2' | head -1 | awk '{print $3","$4}')" >> APM2_metrics.csv
 echo "$SECONDS,$(ps aux | egrep 'APM3' | head -1 | awk '{print $3","$4}')" >> APM3_metrics.csv
 echo "$SECONDS,$(ps aux | egrep 'APM4' | head -1 | awk '{print $3","$4}')" >> APM4_metrics.csv
 echo "$SECONDS,$(ps aux | egrep 'APM5' | head -1 | awk '{print $3","$4}')" >> APM5_metrics.csv
 echo "$SECONDS,$(ps aux | egrep 'APM6' | head -1 | awk '{print $3","$4}')" >> APM6_metrics.csv
}
collect_system_metrics () {
 echo "$SECONDS,$(ifstat | egrep 'ens33' | awk '{print $7","$9}' | sed "s/K//g"),$(iostat | egrep 'sda' | awk '{print $4}'),$(df -m | egrep '/dev/mapper/centos-root' | awk '{print $4}')" >> system_metrics.csv
}

cleanup () {
 kill -9 $PID1
 kill -9 $PID2
 kill -9 $PID3 
 kill -9 $PID4 
 kill -9 $PID5 
 kill -9 $PID6 
 pkill ifstat
}
spawn_executables
while true
do
 collect_process_metrics
 collect_system_metrics
 sleep 5
 echo "$SECONDS"
 if [ $SECONDS -gt 61 ]
 then 
 cleanup 
 break
 fi
done
