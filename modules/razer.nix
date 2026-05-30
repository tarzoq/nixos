#build dependencies failed, will have to retry in the future...
{ config, pkgs, vars, ... }:
{
  #https://nixos.wiki/wiki/Hardware/Razer
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [
    openrazer-daemon
    polychromatic #front-end
  ];
  users.users.${vars.user.name} = { extraGroups = [ "openrazer"]; };
}
