{ config, pkgs, ... }:

{
  #home-manager.users.${USER} = {
  #  home.stateVersion = "${stateVersion}";
  #  imports = [
  #    ./hyprland.nix
  #  ];
  #};
  imports = [
    ./hm/hypridle.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.11";
  #programs.home-manager.enable = true;

  xdg.configFile."hypr/hyprland.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/user/nixos/dotfiles/hyprland/hyprland.conf";
    recursive = true;
  };

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/user/nixos/dotfiles/niri";
    recursive = true;
  };

  xdg.configFile."kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/user/nixos/dotfiles/kitty";
    recursive = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      #hrs = "home-manager --flake /etc/nixos switch";
      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos";
      nru = "sudo nix flake update --flake ~/nixos && nrs";
      nrb = "sudo nixos-rebuild boot --impure --flake ~/nixos";
      vn = "nvim ~/nixos";
      cn = "cd ~/nixos";
    };
  };
}
