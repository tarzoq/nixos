{ config, pkgs, vars, ... }:
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

  home-manager.users."${vars.user.name}" = { config, ... }: {
    programs.bash.shellAliases = {
      t = "tmux";
    };

    home.file.".tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/.tmux.conf";
      recursive = true;
    };
  };
}
