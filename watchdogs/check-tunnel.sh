#!/bin/bash

main(){
    if ! { ip link show oaitun_ue1 && ping -I oaitun_ue1 -c 1 15.0.0.1; } > /dev/null 2>&1; then
        systemctl kill -s SIGTERM oai@ue.service
        echo -e "\n\033[0;34m[Watchdog]\033[0m Missing oaitun_ue1, killing oai@ue.service\033[0m\n" | ts "%Y-%m-%d %H:%M:%S"
        /usr/local/bin/oai-stats.sh tunnel_missing
    fi
}

main "$@"
