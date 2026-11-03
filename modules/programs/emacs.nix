{ config, pkgs, vars, ... }:
{
  #https://github.com/marienz/nix-doom-emacs-unstraightened #nix managed (no need for doom sync)
  modules.niri.imports = "include \"emacs.hm.kdl\"";

  home-manager.users."${vars.user.name}" = {
    programs.doom-emacs = {
      enable = true;
      doomDir = builtins.path {
        name = "doom-config";
        path = /. + "${vars.user.home}/nixos/config/doom";
      };
    };

    services.emacs = { #still runs unstraightened, but gives ability to enable daemon
      enable = true;
      client.enable = true;
      defaultEditor = true;
      startWithUserSession = true;
    };

    home.file."nixos/config/niri/emacs.hm.kdl".text = ''
      binds {
        Super+Mod5+I hotkey-overlay-title="Doom Emacs" {
	  spawn-sh "emacsclient -c -a \"\""; //start daemon if not already running
	}
      }
    '';
  };
}
