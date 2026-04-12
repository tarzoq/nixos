{ config, pkgs, vars, ... }:
{
  home.pointerCursor = {
    package = pkgs.apple-cursor; 
    name = "macOS"; #find theme names=ls $(nix-build '<nixpkgs>' -A apple-cursor --no-out-link)/share/icons
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Create a small config file for Niri to include
  home.file."nixos/config/niri/cursor.hm.kdl".text = ''
    cursor {
        xcursor-theme "${config.home.pointerCursor.name}"
        xcursor-size ${toString config.home.pointerCursor.size}
    }
    environment {
        XCURSOR_THEME "${config.home.pointerCursor.name}"
        XCURSOR_SIZE "${toString config.home.pointerCursor.size}"
    }
  '';

  # Ensure GTK/Qt follow along
  gtk.enable = true;
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
  gtk.gtk4.theme = null; #needed to adopt new behavior
}
