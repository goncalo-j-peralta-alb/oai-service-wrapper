#!/bin/bash
USER=$(users | awk '{print $1}')

echo -e "\n\033[0;34m[Systemd Service]\033[0m Starting OAI\033[0m\n"

cd /home/$USER/oai/Scripts/
if [ "$1" = "ue" ]; then
    # 1. Start the watchdog in the background
    /usr/local/bin/check-tunnel.sh &
    WATCHDOG_PID=$!
    # Add | ts "%Y-%m-%d %H:%M:%S" at the end of the script for timestamps on log file
    #taskset -c 1,2,3 ./nr-uesoftmodem -O ../../../../conf_files/nrUEs/nrue_b205_rooftop.conf | ts "%Y-%m-%d %H:%M:%S"  # --log_config.global_log_level "debug" 
    ./ue_deployment.sh -5floor | ts "%Y-%m-%d %H:%M:%S"
    kill $WATCHDOG_PID 2>/dev/null
elif [ "$1" = "gnb" ]; then
    ./gNB_deployment.sh -5floor | ts "%Y-%m-%d %H:%M:%S"
fi

/usr/local/bin/oai-stats.sh systemd_restart
