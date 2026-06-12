{ config, pkgs, ... }:
{
  dconf.enable = true;

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
