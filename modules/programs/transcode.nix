{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs.stable; [
    handbrake
    makemkv #ffmpeg error on unstable
  ];
}
