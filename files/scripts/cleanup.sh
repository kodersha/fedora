#!/usr/bin/env bash

set -oue pipefail

rm -rf /usr/share/backgrounds/fedora-workstation
rm -rf /usr/share/backgrounds/gnome

rm -r /usr/share/icons/gnome-logo-text.svg
rm -r /usr/share/icons/gnome-logo-text-dark.svg

rm -r /usr/share/applications/org.gnome.evolution-data-server.OAuth2-handler.desktop
rm -r /usr/share/applications/nautilus-autorun-software.desktop

systemctl mask org.gnome.SettingsDaemon.Wacom.service
systemctl mask org.gnome.SettingsDaemon.PrintNotifications.service
systemctl mask org.gnome.SettingsDaemon.Color.service
systemctl mask org.gnome.SettingsDaemon.A11ySettings.service
systemctl mask org.gnome.SettingsDaemon.ScreensaverProxy.service
systemctl mask org.gnome.SettingsDaemon.Sharing.service
systemctl mask org.gnome.SettingsDaemon.Smartcard.service
systemctl mask org.gnome.SettingsDaemon.Housekeeping.service
systemctl mask org.gnome.SettingsDaemon.Power.service

systemctl mask evolution-addressbook-factory
systemctl mask evolution-calendar-factory
systemctl mask evolution-source-registry

systemctl mask tracker-miner-apps 
systemctl mask tracker-miner-fs 
systemctl mask tracker-store

systemctl mask systemd-udev-settle
