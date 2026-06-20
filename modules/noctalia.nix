{ pkgs, inputs, vars, ... }:
{
  modules.autostart.entries = "noctalia-shell";

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ddcutil #desktop monitor brightness control
    qt6.qtwebsockets #hass plugin
    #wtype #clipper

    #override package
    (pkgs.noctalia-shell.override { calendarSupport = true; })
    ];

  #add support for calendar events
  services.gnome.evolution-data-server.enable = true;

  #modules.resume.resumeScript = ''
  #  ${pkgs.bash}/bin/sh ${vars.user.home}/.config/niri/noctalia-restart.hm.sh
  #'';

  home-manager.users."${vars.user.name}" = {
    home.file."nixos/config/niri/noctalia-restart.hm.sh".text = ''
      ${pkgs.procps}/bin/pkill ".quickshell" && sleep 1; ${pkgs.niri}/bin/niri msg action spawn-sh -- "noctalia-shell"
    '';
  };
}
