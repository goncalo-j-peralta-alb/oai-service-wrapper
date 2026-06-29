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
        apt install -y moreutils
    fi
    if ! command -v jq > /dev/null 2>&1; then
        apt install -y jq
    fi

    cp configs/oai-stats.json /var/log/
    cp configs/oai-logrotate /etc/logrotate.d/
    cp configs/oai@.service /etc/systemd/system/
    cp configs/oai-check-late-packets@.service /etc/systemd/system/
    cp configs/oai-check-late-packets@.timer /etc/systemd/system/
    cp configs/oai-logrotate.service /etc/systemd/system/
    cp configs/oai-logrotate.timer /etc/systemd/system/
    cp scripts/* /usr/local/bin/

    if [ "$node" = "ue" ]; then
        cp watchdogs/check-tunnel.sh /usr/local/bin/
        cp configs/oai-check-tunnel.service /etc/systemd/system/
        cp configs/oai-check-tunnel.timer /etc/systemd/system/
    fi

    cp watchdogs/check-late-packets.sh /usr/local/bin/

    systemctl daemon-reload
    systemctl enable oai@$node
    systemctl start oai@$node

    if [ "$node" = "ue" ]; then
        systemctl enable --now oai-check-tunnel.timer
    fi

    systemctl enable --now oai-check-late-packets@$node.timer
    systemctl enable --now oai-logrotate.timer
}

main "$@"
