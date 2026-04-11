{ config, pkgs, vars, ... }:
#https://wiki.nixos.org/wiki/Thunar
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      #thunar-volman #automatic management of drives
    ];
  };
  #needed for persistent preference changes
  programs.xfconf.enable = true;
  
  services.gvfs.enable = true; #mount, trash etc.
  services.tumbler.enable = true; #thumbnail support

  environment.systemPackages = with pkgs; [
    p7zip
  ];
}
