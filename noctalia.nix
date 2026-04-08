{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    imagemagick #required for template processing and wallpaper resizing
    ddcutil #desktop monitor brightness control

    #override package
    (pkgs.noctalia-shell.override { calendarSupport = true; })
    ];

  #add support for calendar events
  services.gnome.evolution-data-server.enable = true;
  
  #services.cliphist = { #clipboard history support
  #  enable = true;
  #  allowImages = true;
  #};

  #services.wlsunset.enable = true; #night light functionality
  ##https://docs.noctalia.dev/getting-started/installation/#dependencies-explained
}
