{ pkgs, inputs, vars, ... }:
{
  modules.autostart.entries = "cat";

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ddcutil #desktop monitor brightness control
    pulseaudio #audio switcher
    #qt6.qtwebsockets #hass plugin
    #wtype #clipper
    glib #phone connect
    sshfs #phone connect
    ];

  #add support for calendar events
  #services.gnome.evolution-data-server.enable = true;

  #modules.resume.resumeScript = ''
  #  ${pkgs.bash}/bin/sh ${vars.user.home}/.config/niri/noctalia-restart.hm.sh
  #'';

  home-manager.users."${vars.user.name}" = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };

    home.file."nixos/config/niri/noctalia-and-vicinae-restart.hm.sh".text = ''
      /run/current-system/sw/bin/systemctl --user restart noctalia.service
      /run/current-system/sw/bin/systemctl --user restart vicinae.service
    '';
  };
}
