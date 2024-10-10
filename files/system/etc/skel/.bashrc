# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.nix-profile/bin:$PATH"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
export HOME_MANAGER_CONFIG=$HOME/.nix-config/home-manager/home.nix
export NIXPKGS_CONFIG=$HOME/.nix-config/nixpkgs/config.nix

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# if [ -z "${NOZSH}" ] && [ $TERM = "xterm" -o $TERM = "xterm-256color" -o $TERM = "screen" ] && type zsh &> /dev/null
# then
#   export SHELL=$(which zsh)
#   if [[ -o login ]]
#   then
#     exec zsh -l
#   else
#     exec zsh
#   fi
# fi
