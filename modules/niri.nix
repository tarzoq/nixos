{ config, lib, pkgs, ... }:
{
  options.niri.enableNvidia = lib.mkEnableOption "Enable import of nvidia.kdl for Niri";

  config = {
    programs.niri = {
     enable = true;
    };

    #xdg.portal = {
    #  enable = true;
    #  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #  config.common.default = "gtk";
    #};
    xdg.portal.config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = [ "kde" ]; # or "kde"
    };

    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = {};

    environment.systemPackages = with pkgs; [
      alacritty #ICE, standard term by niri
      mako #needed for niri config notifications
      xwayland-satellite
      jq #required for json one-liner command
      #xdg-desktop-portal-gtk #troubleshoot audacity gtk scaling issue
    ];
  };
}
