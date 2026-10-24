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
    sortKey = "z_nixos"; #sort in reverse order (so newest gen always is next to Windows entry)
    #press 'd' on whatever entry should be preferred! #https://www.reddit.com/r/archlinux/comments/4l3rhh/comment/d3k86cd/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  };

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
}
