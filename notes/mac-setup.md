# Mac Setup #

## Root Crontab ##

```
# Set permissions so xremap works:
@reboot /usr/bin/chgrp input /dev/uinput
@reboot /usr/bin/chmod 660 /dev/uinput

# Make sleep work:
@reboot bash -c "/usr/bin/echo s2idle > /sys/power/mem_sleep"
@reboot bash -c "/usr/bin/echo 0 > /sys/bus/pci/devices/0000\:01\:00.0/d3cold_allowed"
```

## Function Keys ##

Create `/etc/modprobe.d/applespi.conf` with contents:

```
options applespi fnmode=2
```

Create `/etc/modprobe.d/hid_apple.conf`

```
options hid_apple fnmode=2
```

Update the initrd:

```
sudo update-initramfs -u -k "$(uname -r)"
```

reboot

## Firefox Scrolling ##

Follow instructions from the [Arch Wiki](https://wiki.archlinux.org/title/Firefox/Tweaks#Smooth_scrolling).

## Dark Theme ##

Getting a proper dark theme requires a gsettings tweak:

```
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```
