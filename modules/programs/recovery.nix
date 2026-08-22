{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ddrescue
    dislocker #decrypt bitlocker volumes, FUSE-mounted
    libbde #bdeinfo (BitLocker Drive Encryption library)
    testdisk-qt #photorec and test, perhaps even better than Recuva? (qphotorec for GUI)
  ];
}
