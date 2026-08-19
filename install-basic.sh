#!/usr/bin/bash

#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then
  echo -e "yay was located, moving on.\n"
  yay -Suy
else
  echo -e "yay was not located, please install yay. Exiting script.\n"
  exit
fi

### Disable wifi powersave mode ###
read -n1 -rep 'Would you like to disable wifi powersave? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
  LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
  echo -e "The following has been added to $LOC.\n"
  echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC
  echo -e "\n"
  echo -e "Restarting NetworkManager service...\n"
  sudo systemctl restart NetworkManager
  sleep 3
fi

### Install all of the above pacakges ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
  yay -S --noconfirm hyprland wlroots wayland quickshell # hyprland
  yay -S --noconfirm mako sddm xdg-desktop-portal-hyprland

  yay -S --noconfirm hyprland-qt-support qt5-wayland qt6-wayland

  yay -S --noconfirm hyprpolkitagent polkit polkit-qt5 polkit-qt6

  yay -S --noconfirm bluez bluez-utils firewalld # necessary utils
  yay -S --noconfirm hyprshutdown hyprpaper hyprlock
  yay -S --noconfirm gvfs chrony

  yay -S --noconfirm grim slurp swappy # screenshot utils

  yay -S --noconfirm wofi kitty nm-connection-editor blueman librewolf # necessary apps

  yay -S --noconfirm exfatprogs dosfstools ntfs-3g # disk formats support

  yay -S --noconfirm mesa nvidia-dkms nvidia-utils # gpu drivers

  yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts-emoji # fonts


  echo -e "Starting Services...\n"
  # Start the bluetooth service
  sudo systemctl enable --now bluetooth.service

  # Start the firewall service
  sudo systemctl enable --now firewalld.service
  sudo firewall-cmd --zone=public --remove-service=ssh

  # disable SSH service
  sudo systemctl disable --now sshd.service

  sudo systemctl enable --now chronyd

  # SDDM setup
  sudo systemctl enable sddm.service # enable SDDM
  hypr_path=/usr/share/wayland-sessions/hyprland.desktop

  echo "" > $hypr_path
  
  echo "[Desktop Entry]" >> $hypr_path
  echo "Name=Hyprland" >> $hypr_path
  echo "Comment=Hyprland Wayland Compositor" >> $hypr_path
  echo "Exec=start-hyprland" >> $hypr_path
  echo "Type=Application" >> $hypr_path
  echo "DesktopNames=Hyprland" >> $hypr_path

  sleep 2

  # Clean out other portals
  echo -e "Cleaning out conflicting xdg portals...\n"
  yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi
