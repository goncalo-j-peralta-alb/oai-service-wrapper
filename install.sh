#!/bin/bash

function show_help(){
    echo "Usage: $0 [OPTION]"
    echo "Options:"
    echo "  -ue, --ue   Install UE service"
    echo "  -gnb, --gnb Install gNB service"
    echo "  -h, --help  Show help"
}

main(){
    if ! [ $(id -u) = 0 ]; then
        echo "Must run as root"
        exit 1
    fi

    local node=""

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -ue  | --ue) node="ue" ;;
            -gnb | --gnb) node="gnb" ;;
            -h   | --help) show_help; exit 0 ;;
            *) show_help; exit 1 ;;
        esac
        shift
    done

    if [ -z "$node" ]; then
        show_help
        exit 1
    fi

    if ! command -v ts > /dev/null 2>&1; then
        apt install moreutils -y
    fi
    if ! command -v jq > /dev/null 2>&1; then
        apt install jq -y
    fi

    cp configs/oai-stats.json /var/log/
    cp configs/oai-logrotate /etc/logrotate.d/
    cp configs/oai@.service /etc/systemd/system/
    cp configs/logrotate /etc/cron.hourly/
    cp scripts/* /usr/local/bin/

    if [ "$node" = "ue" ]; then
        cp watchdogs/check-tunnel.sh /usr/local/bin/
        #(crontab -l ; echo "* * * * * /usr/local/bin/check-tunnel.sh >> /var/log/oai.log") | crontab -
    fi

    cp watchdogs/check-late-packets.sh /usr/local/bin/
    (crontab -l ; echo "* * * * * /usr/local/bin/check-late-packets.sh $node >> /var/log/oai.log") | crontab -

    systemctl daemon-reload
    systemctl enable oai@$node
    systemctl start oai@$node
}

main "$@"
