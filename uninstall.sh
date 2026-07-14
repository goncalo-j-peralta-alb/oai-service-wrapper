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

    if crontab -l > /dev/null 2>&1; then
	new_cron=$(crontab -l | grep -v -E "check-tunnel.sh|check-late-packets.sh")
	if [ -z "$new_cron" ]; then
	    crontab -r 2>/dev/null #Remove crontab entirely if it is empty
	else
	    echo "new_cron" | crontab -
	fi
    fi
    rm -f /etc/logrotate.d/oai-logrotate
    rm -f /etc/cron.hourly/logrotate
    rm -f /usr/local/bin/start-oai.sh
    rm -f /usr/local/bin/oai-stats.sh
    rm -f /usr/local/bin/check-tunnel.sh
    rm -f /usr/local/bin/check-late-packets.sh
    rm -f /etc/systemd/system/oai@.service
}

main "$@"
