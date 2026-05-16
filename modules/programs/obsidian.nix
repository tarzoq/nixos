{ pkgs, config, vars, ... }:
{
  #https://wiki.nixos.org/wiki/Obsidian
  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
