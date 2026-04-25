{ config, lib, pkgs, ... }:
{
  options.niri.enableNvidia = lib.mkEnableOption "Enable import of nvidia.kdl for Niri";

  config = {
    environment.sessionVariables.XDG_CURRENT_DESKTOP = "niri";

    programs.niri = {
     enable = true;
    };

    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = {};

    environment.systemPackages = with pkgs; [
      alacritty #ICE, standard term by niri
      #mako #needed for niri config notifications
      xwayland-satellite
      jq #required for json one-liner command
      #xdg-desktop-portal-gtk #troubleshoot audacity gtk scaling issue
    ];
  };
}
