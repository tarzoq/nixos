{ config, pkgs, ... }:
{
  #https://wiki.nixos.org/wiki/Displaylink

  #requires manual installation. Command will be shown in stderr
  #environment.systemPackages = with pkgs; [
  #  displaylink
  #];
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  #force kernel to sign evdi module
  boot.extraModulePackages = [ config.boot.kernelPackages.evdi ];
  boot.kernelModules = [ "evdi" ];
}
