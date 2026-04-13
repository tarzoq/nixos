{ config, lib, osConfig, ... }:
{
  home.file."nixos/config/niri/niri-imports.hm.kdl".text = 
    ''
      include "autostart.hm.kdl"
      include "cursor.hm.kdl"
    ''
    + lib.optionalString osConfig.niri.enableNvidia ''
      include "nvidia.kdl"
    '';
}
