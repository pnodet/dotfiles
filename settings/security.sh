#!/bin/sh

# Enable FileVault
sudo fdesetup enable -user $USER >$HOME/FileVault_recovery_key.txt

# Enable the firewall with logging and stealth mode:
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
