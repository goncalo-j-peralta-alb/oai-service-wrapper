#!/bin/bash

main(){
    if ! ip link show oaitun_ue1 > /dev/null 2>&1; then
        systemctl kill -s SIGTERM oai@ue.service
        echo -e "\n\033[0;34m[Watchdog]\033[0m Missing oaitun_ue1, killing oai@ue.service\033[0m\n"
        /usr/local/bin/oai-stats.sh tunnel_missing
    elif ! ping -I oaitun_ue1 -c 1 15.0.0.1 > /dev/null 2>&1; then
        systemctl kill -s SIGTERM oai@ue.service
        echo -e "\n\033[0;34m[Watchdog]\033[0m oaitun_ue1 up but 15.0.0.1 unreachable, killing oai@ue.service\033[0m\n"
        /usr/local/bin/oai-stats.sh ping_failed
    fi
}

main "$@"
