{ config, pkgs, vars, ... }:
{
  #https://www.youtube.com/watch?v=qlfm3MEbqYA (vimjoyer)
  ############# Launch Options ###########
  #gamescope %command%
  #gamemoderun %command%
  #mangohud %command%

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; #starts game in optimized compositor
  };

  programs.gamemode.enable = true; #daemon that improves game performance

  environment.systemPackages = with pkgs; [
    mangohud #in-game performance monitor
    lutris
    #heroic
    lsfg-vk #lossless scaling
    lsfg-vk-ui #lossless scaling
  ];
}
