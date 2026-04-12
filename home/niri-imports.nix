{ config, lib, vars, ... }:
{
  home.file."nixos/config/niri/niri-imports.hm.kdl".text = ''
    include "autostart.hm.kdl"
    include "cursor.hm.kdl"
    //include "nvidia.kdl"
  '';
}
