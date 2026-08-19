{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dislocker #decrypt bitlocker volumes, FUSE-mounted
    libbde #bdeinfo (BitLocker Drive Encryption library)
  ];
}
