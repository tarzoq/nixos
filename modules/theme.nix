{ config, pkgs, vars, ... }:
let
  ICON_PACKAGE = pkgs.whitesur-icon-theme;
  ICON_NAME = "WhiteSur-dark"; #don't forget to also change in Vicinae
in
{
  home-manager.users."${vars.user.name}" = {
    home.packages = [ ICON_PACKAGE pkgs.base16-schemes ];

    stylix = {
      enable = true;
      autoEnable = false;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/hardhacker.yaml";
    };

    ######## ICONS #########
    stylix.icons = {
      enable = true;
      dark = "${ICON_NAME}";
      package = ICON_PACKAGE;
    };

    ####### Targets ########
    stylix.targets.gnome.enable = true;
    stylix.targets.gtk.enable = true;
    stylix.targets.qt.enable = true;
    stylix.targets.kde.enable = true;

    stylix.targets.mpv.enable = true;

    #gtk = {
    #  enable = true;
    #  colorScheme = "dark";
    #  gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    #  gtk4 = {
    #    theme = null;
    #    extraConfig.gtk-application-prefer-dark-theme = true;
    #  };
    #  gtk3.colorScheme = "dark";
    #  gtk4.colorScheme = "dark";

    #  iconTheme = { name = "${ICON_NAME}"; package = ICON_PACKAGE; };
    #};

    #qt = {
    #  enable = true;
    #  platformTheme.name = "gtk3";
    #};

    #dconf.settings = { #dconf reset -f /org/gnome/desktop/interface/ #to reset theme settings for dconf
    #  "org/gnome/desktop/interface" = {
    #    color-scheme = "prefer-dark";
    #  };
    #};
  };
}
