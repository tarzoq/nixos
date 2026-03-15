{ config, lib, pkgs, ... }:
let
  USER = "user";
  stateVersion = "25.11";
  #dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  #create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in {
  imports =
    [
      ./hardware-configuration.nix
      #./laptop.nix
      ./pc.nix
      #./hibernate.nix
    ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "${stateVersion}"; # Did you read the comment?

}
