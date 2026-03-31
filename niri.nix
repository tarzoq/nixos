{ config, lib, pkgs, ... }:
{
  programs.niri = {
   enable = true;
  };

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  #https://www.reddit.com/r/NixOS/comments/1qo9alr/need_help_with_gdmhyprlanduwsm_problem/
  #https://github.com/NixOS/nixpkgs/issues/484328
  #https://github.com/NixOS/nixpkgs/commit/9128dd3103ce1305cd8e2d4dde2f249608447b4c
  #programs.uwsm = {
  #  enable = true;
  #  waylandCompositors = {
  #    hyprland = {
  #      prettyName = "Hyprland";
  #      comment = "Hyprland compositor managed by UWSM";
  #      binPath = "/run/current-system/sw/bin/start-hyprland";
  #    };
  #  };
  #};
  environment.systemPackages = with pkgs; [
    swayidle
    mako
    xwayland-satellite
  ];
}
