{ config, pkgs, vars, ... }:
#https://wiki.nixos.org/wiki/Nemo
{
  environment.systemPackages = with pkgs; [
    nemo-with-extensions
    thunar #for bulk rename
    file-roller
    gnome-disk-utility
  ];
  services.gvfs.enable = true;
  services.udisks2.enable = true;

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
    #services.udiskie = {
    #  enable = true;
    #  settings = {
    #    program_options = {
    #      file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
    #    };
    #  };
    #};
  };

  #files to declare:
  #~/.config/gtk-3.0/bookmarks
  #rest is dconf
}
