{ config, pkgs, inputs, ... }:
{
  #https://wiki.nixos.org/wiki/Dolphin
  nixpkgs.overlays = [ inputs.dolphin-overlay.overlays.default ];

  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dolphin
  ];
}
