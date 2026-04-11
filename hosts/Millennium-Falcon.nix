{ config, pkgs, ... }:
{
  imports =
    [
      ../common.nix
      ../modules/nvidia.nix
    ];
  modules.nvidia.nvidiaBusId = "PCI:1@0:0:0";
  modules.nvidia.amdBusId = "PCI:16@0:0:0";

  services.hardware.openrgb.motherboard = "amd";

  #environment.systemPackages = with pkgs; [
  #  nvtopPackages.amd #or full for all 
  #];
}
