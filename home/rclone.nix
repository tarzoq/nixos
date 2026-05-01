{ config, pkgs, vars, ... }:
{
  ########## First Run ############
  # rclone config reconnect gdrive:
  # systemctl --user start rclone-gdrive
  #https://claude.ai/chat/02eecf28-1564-4778-b5e6-7b4d1f6eb0f9
  #https://rclone.org/drive/#making-your-own-client-id

  home.packages = [ pkgs.rclone ];
  xdg.configFile."rclone" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/rclone";
    recursive = true;
  };

  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "rclone Google Drive mount";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p '%h/mnt/Google Drive'";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive:/ '%h/mnt/Google Drive' \
          --vfs-cache-mode writes
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -uz '%h/mnt/Google Drive'";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
