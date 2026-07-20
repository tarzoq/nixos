{ config, pkgs, vars, ... }:
{
  imports = [ 
    ./programs/sheetmusicviewer.nix
  ];

  ##### Tool that can potentially emulate keypresses so could enter binds instead of rewriting their actions here ######
  #programs.ydotool.enable = true;
  #users.users.${vars.user.name}.extraGroups = [ "ydotool" ];

  modules.niri.imports = "include \"piano.hm.kdl\"";

  home-manager.users."${vars.user.name}" = {
    home.file."nixos/config/niri/piano.hm.kdl".text = ''
      binds {
        Super+Mod5+1 hotkey-overlay-title="Mode Toggle: Piano" { 
          spawn-sh "
            currentTransform=$(niri msg --json focused-output | jq .logical.transform)
	    caffeineState=$(test -f $XDG_RUNTIME_DIR/noctalia-caffeine-enabled.state; echo $?)
            
            if [ $currentTransform = '\"Normal\"' ]; then
              //rotate screen 180°
              niri msg output $(niri msg --json focused-output | jq -r '.name') transform 270

              //keep awake on
              noctalia msg caffeine-enable

              //start sheetmusicviewer
	      sheet-music-viewer
            else
              //rotate screen normal
              niri msg output $(niri msg --json focused-output | jq -r '.name') transform normal

              //keep awake off
	      if [ \"$caffeineState\" -ne 0 ]; then
                noctalia msg caffeine-disable
	      fi

	      //kill sheetmusicviewer
	      programID=$(niri msg --json windows | jq -r '.[] | select(.[\"app_id\"] == \"SheetMusicViewer\") | .id')
	      niri msg action close-window --id $programID
            fi
          "; 
        }
      }
    '';
  };
}
