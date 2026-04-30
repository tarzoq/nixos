{ config, lib, vars, ... }:
let
  #list of apps that should be disabled. Use name from XDG autostart
  appsToDisable = [
    "remmina-applet"
  ];

  spawn = "spawn-sh-at-startup";
in {
  #xdg.configFile = lib.genAttrs
  #  (map(name: "autostart/${name}.desktop") appsToDisable)
  #  (path: {
  #    #disable autostart for app in xdg
  #    text = ''
  #      [Desktop Entry]
  #      Type=Application
  #      Hidden=true
  #      X-systemd-skip=true
  #    '';
  #    force = true;
  #    #make sure to remove the backupFileExtension
  #    onChange = "rm -f $HOME/.config/${path}.backup";
  #  });

  home.file."nixos/config/niri/autostart.hm.kdl".text = ''
    ${spawn} "pidof noctalia-shell || noctalia-shell &"
    ${spawn} "pidof kanshi || kanshi &"
    ${spawn} "pidof tailscale systray || tailscale systray &"
    ${spawn} "pidof protonvpn-app || protonvpn-app --start-minimized &"
    ${spawn} "pgrep kdeconnect || kdeconnectd &"
  '';
}
