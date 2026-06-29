```
├── configs
|   ├── oai-logrotate                   # logrotate config file
|   ├── oai-logrotate.service           # hourly logrotate systemd service
|   ├── oai-logrotate.timer             # hourly logrotate timer
|   ├── oai-stats.json                  # stat tracker for crashes
|   ├── oai@.service                    # oai systemd service
|   ├── oai-check-tunnel.service        # tunnel watchdog (ue) systemd service
|   ├── oai-check-tunnel.timer          # tunnel watchdog timer (every 30s)
|   ├── oai-check-late-packets@.service # late-packets watchdog systemd service
|   └── oai-check-late-packets@.timer   # late-packets watchdog timer (every 30s)
├── scripts
|   ├── oai-stats.sh            # script to manage stat counter
|   └── start-oai.sh            # script to start oai
├── watchdogs
|   ├── check-late-packets.sh   # looks for an high amount of late packets
|   └── check-tunnel.sh         # looks for oai tunnel interface
├── install.sh                  # install script, run as sudo 
├── README.md
└── uninstall.sh                # uninstall script, run as sudo
```
