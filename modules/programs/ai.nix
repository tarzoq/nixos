{ config, pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    lmstudio
  ];
}
