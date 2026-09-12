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
      base16Scheme = "${pkgs.base16-schemes}/share/themes/hardhacker.yaml"; #https://tinted-theming.github.io/tinted-gallery/
    };

    ######## ICONS #########
    stylix.icons = {
      enable = true;
      dark = "${ICON_NAME}";
      package = ICON_PACKAGE;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark"; 
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.theme = null; #needed to adopt new behavior
    };
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };

    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };
    home.file.".config/kdeglobals" = { #https://www.reddit.com/r/NixOS/comments/1qkh3zo/quick_tip_if_you_are_using_any_wayland_compositor/
      text = ''
        ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
      '';
    };
  };
}
