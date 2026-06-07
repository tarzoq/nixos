{ config, pkgs, vars, ... }:
{
  imports = [ 
    ./programs/sheetmusicviewer.nix
  ];

  #modules.niri.imports = "include \"piano.hm.kdl\"";

  #home-manager.users."${vars.user.name}" = {
  #  home.file."nixos/config/niri/piano.hm.kdl".text = ''
  #    bind {
  #      Super+Mod5+A hotkey-overlay-title="Mode Toggle: Piano" { spawn-sh ""; }
  #    }
  #  '';
  #};
}
