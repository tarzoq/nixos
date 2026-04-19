{ config, lib, pkgs, ... }:
{
  programs.hyprland = {
   enable = true;
   withUWSM = true; # recommended for most users
   xwayland.enable = true; # Xwayland can be disabled.
  };

  services.displayManager.defaultSession = "hyprland-uwsm";
  #security.pam.services.hyprland.enableGnomeKeyring = true;

  #https://www.reddit.com/r/NixOS/comments/1qo9alr/need_help_with_gdmhyprlanduwsm_problem/
  #https://github.com/NixOS/nixpkgs/issues/484328
  #https://github.com/NixOS/nixpkgs/commit/9128dd3103ce1305cd8e2d4dde2f249608447b4c
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/start-hyprland";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    #hyprlock
    jq #json parser, required for zooming in and out
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    #hypridle
    hyprpaper
    hyprsunset
    hyprpicker
    hyprpwcenter
    hyprshutdown
    hyprmon
    hyprcursor
    hyprpolkitagent
    hyprshot
    # kanshi
    #hyprlandPlugins.hyprspace
    #hyprlandPlugins.hyprexpo
  ];
}
