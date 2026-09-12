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

  home-manager.users."${vars.user.name}" = { lib, ... }: {
    systemd.user.services.nemo-dconf-config = {
      Unit = {
        Description = "Nemo dconf's that couldn't be defined in dconf.settings";
	After = [ "graphical-session.target" ];
	PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
	ExecStart = ''
	  ${pkgs.dconf}/bin/dconf write /org/nemo/preferences/bulk-rename-tool "b'thunar --bulk-rename'"
	'';
	RemainAfterExit = true;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    dconf = {
      settings = {
        "org/nemo/preferences" = {
	  #"bulk-rename-tool" #is defined further up on this page in activation-script. Doing this approach, since defining it here directly or trying to convert the command into ASCII values in a byte array just didn't work
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
  };
  #files to declare:
  #~/.config/gtk-3.0/bookmarks
  #rest is dconf
}
