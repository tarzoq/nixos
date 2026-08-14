{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    handbrake
    stable.makemkv #ffmpeg error on unstable
  ];
}
