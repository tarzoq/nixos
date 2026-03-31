{ config, ... }:

{
  boot.kernelParams = ["resume_offset=65572864"]; # sudo filefrag -v /var/lib/swapfile | head

  boot.resumeDevice = "/dev/disk/by-uuid/253b6ad1-b80b-4441-9081-4e2f54a17782"; # lsblk -f
  
  systemd.services.network-before-hibernate = {
    description = "Stop network before hibernation";
    before = [ "systemd-hibernate.service" ];
    wantedBy = [ "systemd-hibernate.service" ];
    script = ''
      /run/current-system/sw/bin/modprobe -r ath11k_pci
      systemctl stop NetworkManager
    '';
    serviceConfig.Type = "oneshot";
  };
  # lspci -k | grep -A3 -i network
  systemd.services.network-after-hibernate = {
    description = "Start network after hibernation";
    after = [ "post-resume.service" ];
    wantedBy = [ "post-resume.service" ];
    script = ''
      sleep 3
      /run/current-system/sw/bin/modprobe ath11k_pci
      systemctl start NetworkManager
    '';
    serviceConfig.Type = "oneshot";
  };

  swapDevices = [ # https://nixos.wiki/wiki/Hibernation
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32GB in MB
    }
  ];
}