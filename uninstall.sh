#!/bin/bash

main(){
    if ! [ $(id -u) = 0 ]; then
        echo "Must run as root"
        exit 1
    fi

    systemctl disable --now oai-check-tunnel.timer
    systemctl disable --now oai-check-late-packets@ue.timer
    systemctl disable --now oai-check-late-packets@gnb.timer
    systemctl disable --now oai-logrotate.timer
    systemctl disable oai@ue.service
    systemctl stop oai@ue.service
    systemctl disable oai@gnb.service
    systemctl stop oai@gnb.service

    rm -f /etc/logrotate.d/oai-logrotate
    rm -f /usr/local/bin/start-oai.sh
    rm -f /usr/local/bin/oai-stats.sh
    rm -f /usr/local/bin/check-tunnel.sh
    rm -f /usr/local/bin/check-late-packets.sh
    rm -f /etc/systemd/system/oai@.service
    rm -f /etc/systemd/system/oai-check-tunnel.service
    rm -f /etc/systemd/system/oai-check-tunnel.timer
    rm -f /etc/systemd/system/oai-check-late-packets@.service
    rm -f /etc/systemd/system/oai-check-late-packets@.timer
    rm -f /etc/systemd/system/oai-logrotate.service
    rm -f /etc/systemd/system/oai-logrotate.timer

    systemctl daemon-reload
    systemctl reset-failed oai@ue.service oai@gnb.service 2>/dev/null
}

main "$@"
