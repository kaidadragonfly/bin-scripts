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

Mint/Ubuntu:
```
sudo update-initramfs -u -k "$(uname -r)"
```

Fedora:
```
sudo dracut --regenerate-all
```

reboot

## Firefox Scrolling (Mint only) ##

Add `MOZ_USE_XINPUT2 DEFAULT=1` to `/etc/security/pam_env.conf`.

(From here: https://askubuntu.com/questions/853910/how-to-enable-touchscreen-scrolling-in-firefox/994483#994483)

## Dark Theme ##

Getting a proper dark theme requires a gsettings tweak:

```
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

## Alt button menu stuff ##

Set left alt to do /bin/false in the keyboard settings.  (xremap will make left alt right alt for terminal purposes.)

The above is Cinnamon only.  Gnome Shell won't let you bind a global keybinding to juts Alt.

## Speed up DNF ##

From here: https://ostechnix.com/how-to-speed-up-dnf-package-manager-in-fedora/

Add the following to `/etc/dnf/dnf.conf`:

```
max_parallel_downloads=10
fastestmirror=True
```

## Update Lock-Screen Background

From here: https://help.gnome.org/admin/system-admin-guide/stable/desktop-shield.html.en

copy wallpaper into `/opt/wallpaper/` (will need to create that).

```
sudo mkdir /opt/wallpaper/
sudo cp mercy-hand-outstretched.jpg /opt/wallpaper/
```

Create `/etc/dconf/profile/gdm` with the following contents:

```
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
```

Create `/etc/dconf/db/gdm.d/01-screensaver`:

```
[org/gnome/desktop/screensaver]
picture-uri='file:///opt/wallpaper/mercy-hand-outstretched.jpg'
```

Update dconf:

```
sudo dconf update
```

## Fix resolution on external monitor ##

Zoom out using steps here (1.25x1.25)

[https://wiki.archlinux.org/title/HiDPI#Xorg](https://wiki.archlinux.org/title/HiDPI#Xorg)

## Turn of bluetooth on sleep ##

Create `/lib/systemd/system-sleep/unload-load-bt.sh`:

```
#!/bin/sh
# unload/load modules before sleep/resume
#
case $1 in
    pre)
        echo "Going to $2... disable bluetooth"
    /usr/sbin/modprobe -r hci_uart
    /usr/sbin/modprobe -r btintel
        ;;
    post)
        echo "Waking up from $2... restore bluetooth"
    /usr/sbin/modprobe btintel
    /usr/sbin/modprobe hci_uart
    ;;
esac
```

Make the script executable (seems to apply on next reboot):

```
sudo chmod +x /lib/systemd/system-sleep/unload-load-bt.sh
```

## Set startup chime volume ##

Add to root crontab:

```
@reboot /usr/bin/chattr -i /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82
@reboot /usr/bin/bash -c '/usr/bin/printf "\x07\x00\x00\x00\x37" > /sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82'
```
