{ config, pkgs, lib, vars, ...}:
let
  bLeftMenu = menu: let
    configFile = pkgs.writeText "${vars.user.home}/.config/wlr-which-key/bleft.yaml"
      (lib.generators.toYAML {} {
        anchor = "bottom-left";
        inherit menu;
      });
  in
    pkgs.writeShellScriptBin "bLeftMenu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';
  centerMenu = menu: let
    configFile = pkgs.writeText "${vars.user.home}/.config/wlr-which-key/center.yaml"
      (lib.generators.toYAML {} {
        anchor = "center";
        inherit menu;
      });
  in
    pkgs.writeShellScriptBin "centerMenu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';

  #######################################################
  LMETA = "Super+Mod5";
  MOD = "Mod";
in {
  modules.niri.imports = "include \"wlr-which-key.hm.kdl\"";

  home-manager.users."${vars.user.name}" = {
    home.file."nixos/config/niri/wlr-which-key.hm.kdl".text = ''
      binds {
        ${LMETA}+X { spawn-sh "${lib.getExe (bLeftMenu {
            "r" = {
              desc = "OBS Studio";
              cmd = "obs";
            };
            "p" = {
              desc = "Paint (pinta)";
              cmd = "pinta";
            };
            "c" = {
              desc = "Camera (cheese)";
              cmd = "cheese";
            };
            "d" = {
              desc = "Disk Management (gparted)";
              cmd = "gparted";
            };
            "s" = {
              desc = "Sound Management (pavucontrol)";
              cmd = "pavucontrol";
            };
            "n" = {
              desc = "Shutdown Options";
              submenu = {
                "l" = {
                  desc = "Log out";
                  cmd = "niri msg action quit";
                };
                "ö" = {
                  desc = "Suspend";
                  cmd = "systemctl suspend";
                };
                "v" = {
                  desc = "Hibernate";
                  cmd = "systemctl hibernate";
                };
                "a" = {
                  desc = "Shutdown";
                  cmd = "poweroff";
                };
                "s" = {
                  desc = "Restart";
                  cmd = "reboot";
                };
              };
            };
    })}"; }
    ${MOD}+Y { spawn-sh "${lib.getExe (centerMenu {
      "p" = {
        desc = "NixOS Packages";
        cmd = "xdg-open https://search.nixos.org/packages";
      };
      "o" = {
        desc = "NixOS Options";
        cmd = "xdg-open https://search.nixos.org/options";
      };
      "f" = {
        desc = "NixOS 3rd-party Flakes";
        cmd = "xdg-open https://search.nixos.org/flakes";
      };
      "n" = {
        desc = "NixOS Noggle (functions)";
        cmd = "xdg-open https://noogle.dev";
      };
      "w" = {
        desc = "NixOS Wiki";
        cmd = "xdg-open https://search.nixos.org/packages";
      };
    })}"; }
      }
    '';
  };
}
