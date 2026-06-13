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
        "org/nemo/preferences" = {
	  "bulk-rename-tool" = "thunar --bulk-rename";
          "click-double-parent-folder" = true;
          "default-folder-viewer" = "list-view";
          "show-computer-icon-toolbar" = true;
          "show-hidden-files" = true;
          "show-home-icon-toolbar" = true;
          "show-new-folder-icon-toolbar" = true;
          "show-open-in-terminal-toolbar" = true;
          "show-reload-icon-toolbar" = true;
          "show-show-thumbnails-toolbar" = true;
          "show-toggle-extra-pane-toolbar" = true;
          "start-with-dual-pane" = false;
          "tooltips-in-icon-view" = false;
          "tooltips-in-list-view" = false;
          "tooltips-show-birth-date" = false;
	};
	"org/nemo/plugins" = {
	  "disabled-actions" = [ "add-desklets.nemo_action" ];
	};
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
    xdg.configFile."gtk-3.0/bookmarks".text = ''
      file:///home/${vars.user.name}/nixos nixos
      file:///home/${vars.user.name}/Downloads Downloads
      file:///home/${vars.user.name}/Documents Documents
      file:///home/${vars.user.name}/Pictures Pictures
      file:///home/${vars.user.name}/Music Music
      file:///home/${vars.user.name}/Videos Videos
      ${vars.misc.networkShare}
    '';
  };

  #files to declare:
  #~/.config/gtk-3.0/bookmarks
  #rest is dconf
}
