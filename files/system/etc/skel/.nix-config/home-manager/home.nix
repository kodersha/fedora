{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${builtins.getEnv "USER"}";
  home.homeDirectory = "/home/${builtins.getEnv "USER"}";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    appstream-glib
    fastfetch
    topgrade
    obfs4
    gitui
    zstd
    perl
    zsh
    tor
    gh
  ];

  home.sessionVariables = {
    EDITOR = "nano";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Programs
  
  programs.fastfetch.enable = true;
  programs.zsh.enable = true;

  # Config

  home.file.".config/fastfetch/config.jsonc".source = "${config.home.homeDirectory}/.nix-config/nixpkgs/fastfetch/config";
  home.file.".config/fastfetch/logo.txt".source = "${config.home.homeDirectory}/.nix-config/nixpkgs/fastfetch/logo";

  home.file.".config/topgrade.toml".source = "${config.home.homeDirectory}/.nix-config/nixpkgs/topgrade/topgrade";

  home.file.".tor/torrc".source = "${config.home.homeDirectory}/.nix-config/nixpkgs/tor/torrc";
  home.file.".zshrc".source = "${config.home.homeDirectory}/.nix-config/nixpkgs/zsh/zshrc";

  ###
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;

  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = "/usr/bin/sudo /usr/bin/chmod -R 777 $HOME/.nix-profile/share/applications && /usr/bin/update-desktop-database $HOME/.nix-profile/share/applications";
    };
  };
}