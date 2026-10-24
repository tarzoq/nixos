{ config, pkgs, ... }:
{
  imports = [
    ./obs.nix
  ];

  environment.systemPackages = with pkgs.stable; [
    audacity
    #davinci-resolve #https://nixos.wiki/wiki/DaVinci_Resolve
    kdePackages.kdenlive
  ];
}
