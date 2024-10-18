zapret:
  #!/bin/bash
  
  DIRECTORY="/opt/zapret"
  
  CONFIG_URL="https://raw.githubusercontent.com/kodersha/fedora/refs/heads/main/sources/config/zapret/config"
  CONFIG_NAME="config"
  
  HOSTS_URL="https://raw.githubusercontent.com/kodersha/fedora/refs/heads/main/sources/config/zapret/zapret-hosts-user.txt"
  HOSTS_NAME="ipset/zapret-hosts-user.txt"
  
  # Check if rc-local.service is active
  if systemctl is-active --quiet rc-local.service; then
    echo "Zapret service is already running. Nothing to do."
    exit 0
  fi
  
  # Create the directory if it doesn't exist
  if [ ! -d "$DIRECTORY" ]; then
    sudo mkdir -p "$DIRECTORY"
  fi
  
  # Change to the target directory
  cd "$DIRECTORY" || exit
  
  # Download the repository contents
  if [ ! -d "zapret" ]; then
    if ! sudo git clone https://github.com/bol-van/zapret.git --depth=1 .; then
      echo "Failed to clone the repository. Exiting..."
      exit 1
    fi
  else
    echo "Done."
  fi
  
  # Download the first file
  sudo curl -o "$CONFIG_NAME" "$CONFIG_URL"
  
  # Create the ipset subdirectory if it doesn't exist
  sudo mkdir -p "$DIRECTORY/ipset"
  
  # Download the second file, replacing it if it exists
  sudo curl -o "$HOSTS_NAME" "$HOSTS_URL"
  
  # Create /etc/rc.d/rc.local with the required content
  RC_LOCAL="/etc/rc.d/rc.local"
  echo -e "#!/bin/bash\n\nexec bash /opt/zapret/init.d/sysv/zapret start" | sudo tee "$RC_LOCAL" > /dev/null
  
  # Set permissions for rc.local
  sudo chmod 755 "$RC_LOCAL"
  
  # Create /etc/systemd/system/rc-local.service with the required content
  RC_LOCAL_SERVICE="/etc/systemd/system/rc-local.service"
  echo "[Unit]
  Description=Compatibility rc.local
  ConditionPathExists=/etc/rc.d/rc.local
  
  [Service]
  Type=forking
  ExecStart=/etc/rc.d/rc.local
  TimeoutSec=0
  StandardOutput=tty
  RemainAfterExit=yes
  
  [Install]
  WantedBy=multi-user.target" | sudo tee "$RC_LOCAL_SERVICE" > /dev/null
  
  # Execute additional scripts
  if ! sudo bash /opt/zapret/install_bin.sh; then
    echo "Failed to execute install_bin.sh. Exiting..."
    exit 1
  fi
  
  if ! sudo bash /opt/zapret/install_prereq.sh; then
    echo "Failed to execute install_prereq.sh. Exiting..."
    exit 1
  fi
  
  # Reload the systemd manager configuration and start the service
  sudo systemctl daemon-reload
  sudo systemctl enable --now rc-local.service

  echo "Installation successful!"
