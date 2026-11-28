{ config, pkgs, ... }:
{
  #https://wiki.nixos.org/wiki/Tmux
  programs.tmux = {
    enable = true;
    #clock24 = true;
    #extraConfigBeforePlugins = ''
    #  set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
    #'';
    #plugins = [
    #  pkgs.tmuxPlugins.cpu
    #];
  };
}
