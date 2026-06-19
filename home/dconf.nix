{ config, pkgs, ... }:
{
  #dconf already enabled in system config
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };

    "org/gnome/TextEditor" = { #dconf watch /org/gnome/TextEditor/
      keybindings = "vim";
      restore-session = false;
      style-scheme = "peninsula-dark";
    };
  };
}
