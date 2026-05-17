{ config, pkgs, vars, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      "net.lutris.Lutris"
    ];
  };

  #https://github.com/gmodena/nix-flatpak
  services.flatpak.overrides.settings = {
    global = {
      # Force Wayland by default
      #Context.sockets = ["wayland" "!x11" "!fallback-x11"];
      Context = {
        sockets = [ "wayland" "fallback-x11" "system-bus" ];
        filesystems = [ "${vars.user.home}/Games" "/run/media" ];
      };

      Environment = {
        # Force correct theme for some GTK apps
        GTK_THEME = "Adwaita:dark";
      };
    };
  };

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };
}
