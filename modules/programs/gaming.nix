{ config, pkgs, vars, ... }:
{
  #https://www.youtube.com/watch?v=qlfm3MEbqYA (vimjoyer)
  ############# Launch Options ###########
  #gamescope %command%
  #gamemoderun %command%
  #mangohud %command%

  hardware.hid-fanatecff.enable = true; #kernel driver with force feedback support for fanatec

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; #starts game in optimized compositor
    extest.enable = true; #make mouse input from controller work for wayland
  };
  ########## STEAM disable http2 #######################
  home-manager.users."${vars.user.name}" = { lib, ... }: {
    home.activation.steamConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      cfg="$HOME/.steam/steam/steam_dev.cfg"
      key="@nClientDownloadEnableHTTP2PlatformLinux"
      setting="$key 0"

      if [ ! -f "$cfg" ]; then
        mkdir -p "$(dirname "$cfg")"
        echo "$setting" > "$cfg"
      elif ! grep -qF "$setting" "$cfg"; then
        echo "$setting" >> "$cfg"
      fi
    '';
  };
  ########## STEAM disable http2 #######################

  programs.gamemode.enable = true; #daemon that improves game performance
  users.users.${vars.user.name}.extraGroups = [ "gamemode" ];

  environment.systemPackages = with pkgs; [
    mangohud #in-game performance monitor

    #heroic
    lsfg-vk #lossless scaling
    lsfg-vk-ui #lossless scaling

    #https://wiki.nixos.org/wiki/Prism_Launcher
    prismlauncher #minecraft
  ];
}
