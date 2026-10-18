{ config, pkgs, lib, ... }:
#https://nix-community.github.io/lanzaboote/getting-started/prepare-your-system.html#configure-nixos-with-flakes
#https://nix-community.github.io/lanzaboote/explanation/automatic-provisioning.html
{
  environment.systemPackages = [ pkgs.sbctl pkgs.cmatrix ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      #autoReboot = true;
    };
  };

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
}
