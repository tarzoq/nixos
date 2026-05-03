{ config, pkgs, vars, ... }:
{
  #https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;

  users.extraGroups.vboxusers.members = [ "${vars.user.name}" ];
}
