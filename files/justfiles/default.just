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

  echo -e "❯ Adding entries to hosts..."

  # List of entries to add
  HOST_ENTRIES=(
    "127.0.1.1 fedora"
    "204.12.192.222 ab.chatgpt.com"
    "204.12.192.222 api.openai.com"
    "204.12.192.222 auth.openai.com"
    "204.12.192.222 auth0.openai.com"
    "204.12.192.222 cdn.auth0.com"
    "204.12.192.222 cdn.oaistatic.com"
    "204.12.192.222 chatgpt.com"
    "204.12.192.222 files.oaiusercontent.com"
    "204.12.192.222 platform.openai.com"
    "204.12.192.222 tcr9i.chat.openai.com"
    "204.12.192.222 webrtc.chatgpt.com"
    "204.12.192.222 www-growth.scdn.co"
  )

  for entry in "${HOST_ENTRIES[@]}"; do
    if ! grep -qF "$entry" /etc/hosts; then
      echo "$entry" | sudo tee -a /etc/hosts > /dev/null
      echo -e "${GREEN}❯ Added: $entry${RESET}"
    else
      echo -e "${GREEN}❯ Already exists: $entry${RESET}"
    fi
  done

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
    echo "❯ Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Snowy-Fluffy/zapret.installer/refs/heads/main/installer.sh)"
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
