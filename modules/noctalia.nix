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
    #### alexander/screen-toolkit #######
    slurp
    grim
    tesseract
    imagemagick
    zbar
    gpu-screen-recorder
    wl-screenrec
    wf-recorder
    satty
    translate-shell
    #### alexander/screen-toolkit #######
    ### whyoolw/dropwall ###
    #(stable.python3.withPackages (python-pkgs: with python-pkgs; [
    #  pygobject3 #https://discourse.nixos.org/t/no-module-named-gi/58158/3
    #]))
    #gtk3
    #gtk-layer-shell
    ### whyoolw/dropwall ###
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
