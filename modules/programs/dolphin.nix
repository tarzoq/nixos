{ config, pkgs, inputs, ... }:
#https://wiki.nixos.org/wiki/Dolphin
{
  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.baloo
  ];

  #make it the default file browser
  xdg = {
    mime.defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "application/x-gnome-saved-search" = [ "org.kde.dolphin.desktop" ];
    };
  };

  #avoid build failure from unstable
  nixpkgs.overlays = [
    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
        
        overlays = [ inputs.dolphin-overlay.overlays.default ];
      };
    })
  ];
}
