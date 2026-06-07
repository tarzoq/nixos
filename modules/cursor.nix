{ config, pkgs, vars, ... }:
let
  CURSOR_PACKAGE = pkgs.apple-cursor;
  CURSOR_NAME = "macOS";
  CURSOR_SIZE = 22;
in
{
  modules.niri.imports = "include \"cursor.hm.kdl\"";

  home-manager.users."${vars.user.name}" = {
    #home.pointerCursor = {
    #  package = CURSOR_PACKAGE;
    #  name = "${CURSOR_NAME}"; #find theme names=ls $(nix-build '<nixpkgs>' -A apple-cursor --no-out-link)/share/icons
    #  size = CURSOR_SIZE;
    #  gtk.enable = true;
    #  x11.enable = true;
    #};
    #gtk.gtk4.theme = null; #needed to adopt new behavior

    stylix.cursor = {
      name = "${CURSOR_NAME}";
      package = CURSOR_PACKAGE;
      size = CURSOR_SIZE;
    };

    # Create a small config file for Niri to include
    home.file."nixos/config/niri/cursor.hm.kdl".text = ''
      cursor {
          xcursor-theme "${CURSOR_NAME}"
          xcursor-size ${toString CURSOR_SIZE}
      }
      environment {
          XCURSOR_THEME "${CURSOR_NAME}"
          XCURSOR_SIZE "${toString CURSOR_SIZE}"
      }
    '';

    home.file.".local/share/flatpak/overrides/global".text = ''
      [Environment]
      XCURSOR_THEME="${CURSOR_NAME}"
      XCURSOR_SIZE=${toString CURSOR_SIZE}
    '';

    ########## flatpak fix ##########
    home.file.".icons/${CURSOR_NAME}".source = "${CURSOR_PACKAGE}/share/icons/${CURSOR_NAME}";
  };
  services.flatpak.overrides.settings = {
    global = {
      Environment = {
        #XCURSOR_PATH = "${vars.user.home}/.icons";
	XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        XCURSOR_THEME = "${CURSOR_NAME}";
        XCURSOR_SIZE = "${toString CURSOR_NAME}";
      };
    };
    ########## END flatpak fix ##########
  };
}
