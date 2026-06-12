{ config, pkgs, ... }:
let
  ICON_PACKAGE = pkgs.whitesur-icon-theme;
  ICON_NAME = "WhiteSur-dark"; #don't forget to also change in Vicinae
in
{
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  #stylix = {
  #  enable = true;
  #  autoEnable = false;
  #  polarity = "dark";
  #  base16Scheme = {
  #    base00 = "1e1e2e"; # Background
  #    base01 = "181825"; # Lighter background
  #    base02 = "313244"; # Selection background
  #    base03 = "45475a"; # Comments
  #    base04 = "585b70"; # Dark foreground
  #    base05 = "cdd6f4"; # Default Text
  #    base06 = "f5e0dc"; # Lighter foreground
  #    base07 = "b4befe"; # Lightest foreground
  #    base08 = "f38ba8"; # Variables
  #    base09 = "fab387"; # Integers
  #    base0A = "f9e2af"; # Classes
  #    base0B = "a6e3a1"; # Strings
  #    base0C = "94e2d4"; # Support
  #    base0D = "89b4fa"; # Functions
  #    base0E = "cba6f7"; # Keywords
  #    base0F = "f2cdcd"; # Deprecated
  #  };
  #};
  ######## ICONS #########
  home.packages = [ ICON_PACKAGE ];
  #stylix.icons = {
  #  enable = true;
  #  dark = "${ICON_NAME}";
  #  package = ICON_PACKAGE;
  #};

  gtk = {
    iconTheme = {
      name = "${ICON_NAME}";
      package = ICON_PACKAGE;
    };
  };
  qt = {
    platformTheme.name = "gtk";
  };
}
