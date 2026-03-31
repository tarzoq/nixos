## 1. Define the Path Unit
  #systemd.paths."watcher-home.nix" = {
  #  wantedBy = [ "multi-user.target" ];
  #  pathConfig = {
  #    PathChanged = "/etc/nixos/home.nix"; # Or PathExists, DirectoryNotEmpty, etc.
  #    Unit = "watcher-home.nix.service"; # The service to activate
  #  };
  #};

  ##2. Define the corresponding Service
  #systemd.services."watcher-home.nix" = {
  #  description = "Watch home.nix for changes";
  #  serviceConfig = {
  #    Type = "oneshot";
  #    User = "user";
  #    #ExecStart = "${pkgs.bash}/bin/bash -c '/run/current-system/sw/bin/brave' &"; 
  #    ExecStart = "${pkgs.bash}/bin/bash -c '/run/current-system/sw/bin/notify-send \"Home Manager\" \"Rebuild Done!\"'"; 
  #  };
  #  environment.DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus";
  #  unitConfig = {
  #    StartLimitBurst = 10;
  #    StartLimitIntervalSec = 60;
  #  };
  #};