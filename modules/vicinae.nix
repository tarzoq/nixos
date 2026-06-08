{ config, pkgs, vars, ... }:
{
  #environment.systemPackages = with pkgs; [
  #  vicinae
  #];

  #dynamic theming: 
  #https://docs.vicinae.com/theming/matugen

  home-manager.users."${vars.user.name}" = {
    programs.vicinae = {
      enable = true;
      #systemd.enable = true;
    };
  };
}
