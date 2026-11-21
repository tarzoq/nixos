{ config, pkgs, vars, ... }:
let
  emacsPackage = pkgs.emacs-pgtk;
  startEmacs = ''${emacsPackage}/bin/emacsclient -c -a ""'';
  startEmacsEscape = ''${emacsPackage}/bin/emacsclient -c -a \"\"'';
in {
  #https://github.com/marienz/nix-doom-emacs-unstraightened #nix managed (no need for doom sync)
  modules.niri.imports = "include \"emacs.hm.kdl\"";

  home-manager.users."${vars.user.name}" = {
    programs.doom-emacs = {
      enable = true;
      emacs = emacsPackage;
      doomDir = builtins.path {
        name = "doom-config"; #name of resulting path in nix-store
        path = "${vars.user.home}/nixos/config/doom"; #path to private config
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
	  spawn-sh "${startEmacsEscape}"; //start daemon if not already running
	}
      }
    '';

    xdg.configFile."dummy-triggers/doomemacs" = {
      source = "${vars.user.home}/nixos/config/doom";
      recursive = true;

      #restart emacs daemon and start emacsclient if previously running when any changes have been made to any Emacs-configurations in the doom-folder
      onChange = ''
        #isRunning=$(${pkgs.procps}/bin/pgrep emacsclient || true)

        ${pkgs.systemd}/bin/systemctl --user restart emacs.service & 

        #if [ -n "$isRunning" ]; then
        #  ${startEmacs} &
        #fi
      '';
    };
  };
}
