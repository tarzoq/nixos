{ config, pkgs, ... }:
{
  imports =
    [
      ../common.nix
      ../modules/nvidia.nix
      ../modules/wol.nix
      ../modules/programs/gaming.nix
      ../modules/programs/ai.nix
      ../modules/programs/transcode.nix
      ../modules/programs/recovery.nix
      ../config/misc/vopono.nix
    ];
  modules.autostart.entries = "steam";

  modules.nvidia.nvidiaBusId = "PCI:1@0:0:0";
  modules.nvidia.amdBusId = "PCI:16@0:0:0";

  modules.wol.card = "enp12s0";

  services.hardware.openrgb.motherboard = "amd";
}
