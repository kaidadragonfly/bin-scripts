# Mac Setup #

## Root Crontab ##

# Set permissions so xremap works:
@reboot /usr/bin/chgrp input /dev/uinput
@reboot /usr/bin/chmod 660 /dev/uinput

# Make sleep work:
@reboot bash -c "/usr/bin/echo s2idle > /sys/power/mem_sleep"
@reboot bash -c "/usr/bin/echo 0 > /sys/bus/pci/devices/0000\:01\:00.0/d3cold_allowed"
