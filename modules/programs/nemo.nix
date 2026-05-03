{ config, pkgs, vars, ... }:
#https://wiki.nixos.org/wiki/Nemo
{
  environment.systemPackages = with pkgs; [
    nemo-with-extensions
  ];
  services.gvfs.enable = true;
}
