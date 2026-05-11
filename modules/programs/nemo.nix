{ config, pkgs, vars, ... }:
#https://wiki.nixos.org/wiki/Nemo
{
  environment.systemPackages = with pkgs; [
    nemo-with-extensions
    thunar #for bulk rename
  ];
  services.gvfs.enable = true;

  #make it the default file browser
  xdg = {
    mime.defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
    };
  };

  home-manager.users."${vars.user.name}" = {
    dconf = {
      settings = {
          "org/cinnamon/desktop/applications/terminal" = {
              exec = "kitty";
          };
      };
    };
  };
}
