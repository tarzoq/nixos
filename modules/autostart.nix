{ config, lib, vars, ... }:
let
  #list of apps that should be disabled. Use name from XDG autostart
  appsToDisable = [
    "remmina-applet"
  ];

  spawn = "spawn-at-startup";
  spawn-sh = "spawn-sh-at-startup";
in {

  ######### Boilerplate ############
  #modules.autostart.entries = "PROGRAM";
  ##################################

  options.modules.autostart = {
    entries = lib.mkOption {
      type = lib.types.lines;
      default = null;
      description = "Programs to autostart";
    };
    baseEntries = lib.mkOption {
      type = lib.types.lines;
        default = ''
	  kanshi
          tailscale systray
          kdeconnectd
          thunderbird
          discord
	  protonvpn-app --start-minimized
	  signal-desktop
          teams-for-linux
	  spotify
      '';
    };
  };
  config = let
    cfg = config.modules.autostart;
    allEntries = cfg.entries + "\n" + cfg.baseEntries;
    lines = lib.filter (l: l != "") 
      (map lib.trim (lib.splitString "\n" allEntries));
    catContent = lib.concatMapStrings (prog: ''
      ${spawn-sh} "pgrep '-f ${prog}' || ${prog} &"
    '') lines;
  in lib.mkIf (lines != []) {
    modules.niri.imports = "include \"autostart.hm.kdl\"";
    home-manager.users."${vars.user.name}" = {
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
        ${catContent}
      '';
    };
  };
}
