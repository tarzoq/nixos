{ config, pkgs, vars, ... }:
{
  #dynamic theming: 
  #https://docs.vicinae.com/theming/matugen

  home-manager.users."${vars.user.name}" = {
    programs.vicinae = {
      enable = true;
    };
  };
}
