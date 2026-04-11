{ config, pkgs, vars, ... }:
{
  #https://wiki.nixos.org/wiki/Dolphin
  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dolphin
  ];
}
