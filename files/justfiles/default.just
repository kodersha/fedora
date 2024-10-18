complete:
  #!/usr/bin/bash
  
  # Define color codes
  GREEN="\e[32m"
  YELLOW="\e[33m"
  RED="\e[31m"
  RESET="\e[0m"

  echo ""

  # Check if the Tor service is already running
  echo -e "❯ Installing Tor..."

  if ! systemctl is-active --quiet tor; then    
    # Check and create necessary directories for Tor
    if [ ! -d /var/lib/tor ]; then
      echo "❯ Creating necessary directory: /var/lib/tor..."
      sudo mkdir -p /var/lib/tor
      sudo chown -R toranon:toranon /var/lib/tor
      sudo chmod -R 700 /var/lib/tor
    else
      echo "❯ Directory /var/lib/tor already exists."
    fi

    # Check and create log directory for Tor
    if [ ! -d /var/log/tor ]; then
      echo "❯ Creating log directory: /var/log/tor..."
      sudo mkdir -p /var/log/tor
      sudo chown -R toranon:toranon /var/log/tor
      sudo chmod -R 700 /var/log/tor
    else
      echo "❯ Log directory /var/log/tor already exists."
    fi

    echo "❯ Enabling and starting the Tor service..."
    sudo systemctl enable --now tor
    
    echo -e "${GREEN}❯ Done.${RESET}"
  else
    echo -e "${GREEN}❯ Tor is already running.${RESET}"
  fi
    echo ""

  echo -e "❯ Adding entry to hosts..."
  # Check if the line 127.0.1.1 fedora exists in /etc/hosts
  if ! grep -q "127.0.1.1 fedora" /etc/hosts; then
    echo "127.0.1.1 fedora" | sudo tee -a /etc/hosts > /dev/null
    echo -e "${GREEN}❯ Done.${RESET}"
  else
    echo -e "${GREEN}❯ Hosts already exists.${RESET}"
  fi
  echo ""

  echo -e "❯ Install flatpak overrides..."
  # Check if Flatpak is installed
  if ! command -v flatpak &> /dev/null; then
    echo -e "${RED}❯ Flatpak is not installed. Please install Flatpak first.${RESET}"
    echo ""
    exit 1
  fi
  
  # Check if the necessary overrides are already set
  if flatpak override --show | grep -q "xdg-config/gtk-3.0"; then
    echo -e "${GREEN}❯ Override for gtk-3.0 is already set.${RESET}"
  else
    echo "❯ Setting override for gtk-3.0..."
    sudo flatpak override --filesystem=xdg-config/gtk-3.0
    echo -e "${GREEN}❯ Done.${RESET}"
  fi
  
  if flatpak override --show | grep -q "xdg-config/gtk-4.0"; then
    echo -e "${GREEN}❯ Override for gtk-4.0 is already set.${RESET}"
  else
    echo "❯ Setting override for gtk-4.0..."
    sudo flatpak override --filesystem=xdg-config/gtk-4.0
    echo -e "${GREEN}❯ Done.${RESET}"
  fi
  echo ""

  echo -ne "${YELLOW}❯ Do you want to install stylepak? (y/n): ${RESET}"
  read answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "❯ Installing stylepak..."
    just --justfile /usr/share/ublue-os/just/60-custom.just stylepak
    echo ""
  else
    echo ""
  fi

  # Ask the user for confirmation
  echo -ne "${YELLOW}❯ Do you want to install zapret? (y/n): ${RESET}"
  read answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "❯ Installing zapret..."
    just --justfile /usr/share/ublue-os/just/60-custom.just zapret
    echo ""
  else
    echo ""
  fi

  ###

  echo -e "${GREEN}❯ All done!${RESET}"

# Regenerate GRUB config, useful in dual-boot scenarios where a second operating system isn't listed
regenerate-grub:
  #!/usr/bin/bash
  if [ -d /sys/firmware/efi ]; then
    sudo grub2-mkconfig -o /etc/grub2-efi.cfg
  else
    sudo grub2-mkconfig -o /etc/grub2.cfg
  fi
