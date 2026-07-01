#!/bin/bash

main(){
    local node=$1

    if [[ "$node" != "ue" && "$node" != "gnb" ]]; then
        echo "Usage: $0 [ue|gnb]"
        exit 1
    fi

    if [ $(tail -n 10 /var/log/oai.log | grep -o "L" | wc -l) -gt 10000 ] ; then
        systemctl kill -s SIGTERM oai@${node}.service
        echo -e "\n\033[0;34m[Watchdog]\033[0m Late Packets found, killing oai@${node}.service\033[0m\n" | ts "%Y-%m-%d %H:%M:%S"
        /usr/local/bin/oai-stats.sh late_packets
    fi
}

main "$@"
