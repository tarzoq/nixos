{ config, pkgs, vars, ... }:
{
  #environment.systemPackages = with pkgs; [
  #  vicinae
  #];

  home-manager.users."${vars.user.name}" = {
    programs.vicinae = {
      enable = true;
      #systemd.enable = true;
    };
  };
}
