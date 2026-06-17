{ config, pkgs, vars, ... }:
{
  imports = [ 
    ./programs/sheetmusicviewer.nix
  ];

  #programs.ydotool.enable = true;
  #users.users.${vars.user.name}.extraGroups = [ "ydotool" ];

  modules.niri.imports = "include \"piano.hm.kdl\"";

  home-manager.users."${vars.user.name}" = {
    home.file."nixos/config/niri/piano.hm.kdl".text = ''
      binds {
        Super+Mod5+1 hotkey-overlay-title="Mode Toggle: Piano" { 
          spawn-sh "
            currentTransform=$(niri msg --json focused-output | jq .logical.transform)
            
            if [ $currentTransform = '\"Normal\"' ]; then
              //rotate screen 180°
              niri msg output $(niri msg --json focused-output | jq -r '.name') transform 270

              //keep awake on
              noctalia-shell ipc call idleInhibitor enable

              //start sheetmusicviewer
	      sheet-music-viewer
            else
              //rotate screen normal
              niri msg output $(niri msg --json focused-output | jq -r '.name') transform normal

              //keep awake off
              noctalia-shell ipc call idleInhibitor disable

	      //kill sheetmusicviewer
	      pkill -f sheet-music-viewer
            fi
          "; 
        }
      }
    '';
  };
}
