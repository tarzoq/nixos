# Idea with this file was to have all you need to change during new installation in here, so making a copy of this file and making your changes and not uploading them to git would help.

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
