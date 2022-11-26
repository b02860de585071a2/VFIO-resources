#!/bin/bash

# Log everything for analysis
exec 19>/home/[USERNAME]/log/start.log
BASH_XTRACEFD=19
set -x

# Stop X
pkill -15 Xorg

# Daemon: "You'll have to pry nvidia_modeset from my cold, dead hands."
# Me: "So be it."
systemctl stop nvidia-persistenced.service

# Unbind framebuffer (this method seems to work better than 'echo $text > $file')
echo efi-framebuffer.0 | sudo tee /sys/bus/platform/drivers/efi-framebuffer/unbind



# Black screen fixes

# Stop the getty first so we can set our parameters
systemctl stop getty@tty1.service

GETTY_PATH="/etc/systemd/system/getty@tty1.service.d"

mv "$GETTY_PATH/skip-username.conf" "$GETTY_PATH/autologin.conf"

echo -e "[Service] \nExecStart= \nExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin [USERNAME] %I \$TERM" > "$GETTY_PATH/autologin.conf"

# Reload with our new parameters for when the VM exits next
systemctl daemon-reload
