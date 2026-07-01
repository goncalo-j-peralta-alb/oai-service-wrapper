#!/bin/bash

main(){
    if ! [ $(id -u) = 0 ]; then
        echo "Must run as root"
        exit 1
    fi

    systemctl disable oai@ue.service
    systemctl stop oai@ue.service
    systemctl disable oai@gnb.service
    systemctl stop oai@gnb.service
    systemctl daemon-reload

    crontab -l | grep -v "/usr/local/bin/check-tunnel.sh" | crontab -
    crontab -l | grep -v "/usr/local/bin/check-late-packets.sh" | crontab -
    rm -f /etc/logrotate.d/oai-logrotate
    rm -f /etc/cron.hourly/logrotate
    rm -f /usr/local/bin/start-oai.sh
    rm -f /usr/local/bin/oai-stats.sh
    rm -f /usr/local/bin/check-tunnel.sh
    rm -f /usr/local/bin/check-late-packets.sh
    rm -f /etc/systemd/system/oai@.service
}

main "$@"
