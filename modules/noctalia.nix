{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ddcutil #desktop monitor brightness control
    qt6.qtwebsockets #hass plugin
    wtype #clipper

    #override package
    (pkgs.noctalia-shell.override { calendarSupport = true; })
    ];

  #add support for calendar events
  services.gnome.evolution-data-server.enable = true;
}
