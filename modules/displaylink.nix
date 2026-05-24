{ config, pkgs, ... }:
{
  #https://wiki.nixos.org/wiki/Displaylink

  #requires manual installation. Command will be shown in stderr
  environment.systemPackages = with pkgs; [
    displaylink
  ];
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
}
