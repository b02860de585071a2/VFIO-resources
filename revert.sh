#!/bin/bash

# Log everything for analysis
exec 19>/home/[USERNAME]/log/revert.log
BASH_XTRACEFD=19
set -x

# Rebind framebuffer (hopefully)
echo efi-framebuffer.0 | sudo tee /sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Nvidia daemon
systemctl restart nvidia-persistenced.service



# Black screen fixes

# Start the getty so we can use it
systemctl restart getty@tty1.service

# Set our parameters
GETTY_PATH="/etc/systemd/system/getty@tty1.service.d"

mv "$GETTY_PATH/autologin.conf" "$GETTY_PATH/skip-username.conf"

echo -e "[Service] \nExecStart= \nExecStart=-/sbin/agetty -o '-p -- [USERNAME]' --noclear --skip-login - \$TERM" > "$GETTY_PATH/skip-username.conf"

# Reload with our new parameters for when the VM starts next, and launch an X session (as me)
systemctl daemon-reload &&
su [USERNAME] --session-command="startx > /dev/tty1"
