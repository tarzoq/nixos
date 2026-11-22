{ config, pkgs, vars, ... }:
let
  emacsPackage = pkgs.emacs-pgtk;
  emacsBin = "${emacsPackage}/bin/emacsclient";
  startEmacs = ''${emacsBin} -c -a \"\"'';
  startEmacsNoEscape = ''${emacsBin} -c -a ""'';
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
        Mod+Z hotkey-overlay-title="Doom Emacs" {
          spawn-sh "${startEmacs}"; //start daemon if not already running
        }
        Super+Mod5+I hotkey-overlay-title="NixOS Configuration: Doom Emacs" {
          spawn-sh "${startEmacs} \"~/nixos\""; //start daemon if not already running
        }
        Mod+G hotkey-overlay-title="Magit: NixOS Configuration (Doom Emacs)" {
          spawn-sh "${startEmacs} -e '(progn (magit-status \"~/nixos\") (magit-fetch-all nil))'" //open magit in emacs and fetch-all
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
