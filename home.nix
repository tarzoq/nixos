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
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      hrs = "home-manager --flake /etc/nixos switch";
      nrs = "sudo nixos-rebuild switch";
      nrb = "sudo nixos-rebuild boot";
      #test = "bash -c 'pkill waybar && waybar' & disown";
      vn = "sudo nvim /etc/nixos";
      cn = "cd /etc/nixos";
    };
  };
}
