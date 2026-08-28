{ config, pkgs, vars, ... }:
{
  #https://wiki.nixos.org/wiki/OBS_Studio
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };
  environment.systemPackages = with pkgs; [
    obs-cmd
  ];

  modules.niri.imports = "include \"obs.hm.kdl\"";
  home-manager.users."${vars.user.name}" = { lib, ... }: let
    OBS_WEBSOCKET_CONFIG = "${vars.user.home}/.config/obs-studio/plugin_config/obs-websocket/config.json";
    SECRET_FILE = "${vars.user.home}/.local/state/obs-studio_websocket-secret";
    SECRET_WEBSOCKET = "$(cat ${SECRET_FILE})";

    obsConfigTemplate = pkgs.writeText "obs_websocket-config-template.json" ''
      {
        "alerts_enabled": false,
        "auth_required": true,
        "first_load": false,
        "server_enabled": true,
        "server_password": "@WEBSOCKET_SECRET@",
        "server_port": 4455
      }
    '';
    OBS_CMD = "obs-cmd --websocket obsws://localhost:4455/${SECRET_WEBSOCKET}";
  in {
    ######################### KEYBINDS ############################
    home.file."nixos/config/niri/obs.hm.kdl".text = ''
      binds {
        Mod+KP_Insert { spawn-sh "${OBS_CMD} scene switch Camera"; } //0
        Mod+KP_End { spawn-sh "${OBS_CMD} scene switch Scene"; } //1

        Mod+KP_Subtract { spawn-sh "${OBS_CMD} recording toggle"; } //minus
      }
    '';
    ######################### KEYBINDS ############################

    home.activation.obsWebsocketConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f "${SECRET_FILE}" ]; then
        run ${pkgs.openssl}/bin/openssl rand -hex 32 > "${SECRET_FILE}"
        run chmod 600 "${SECRET_FILE}"
      fi

      run mkdir -p "$(dirname "${OBS_WEBSOCKET_CONFIG}")"
      run sed "s|@WEBSOCKET_SECRET@|${SECRET_WEBSOCKET}|" ${obsConfigTemplate} > "${OBS_WEBSOCKET_CONFIG}"
    '';
  };
}
