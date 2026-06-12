{ config, pkgs, inputs, vars, ... }:
{
  imports =
    [
      # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4

      ../common.nix
      ../modules/amdgpu.nix
      ../modules/tlp.nix
      ../modules/hibernate.nix
      ../modules/resumeScript.nix
      ../modules/programs/gaming.nix
      ../modules/piano.nix
    ];
  modules.hibernate.resumeOffset = 4278272;
  modules.hibernate.diskUuid = "253b6ad1-b80b-4441-9081-4e2f54a17782";
  modules.hibernate.ramGb = 32;
  #modules.hibernate.hibernateScript = ''
  #  /run/current-system/sw/bin/modprobe -r ath11k_pci;
  #'';
  #modules.hibernate.resumeScript = ''
  #  /run/current-system/sw/bin/modprobe ath11k_pci;
  #'';

  modules.resume.downScript = ''
    /run/current-system/sw/bin/modprobe -r ath11k_pci;
    /run/current-system/sw/bin/systemctl stop NetworkManager
  '';
  modules.resume.resumeScript = ''
    /run/current-system/sw/bin/modprobe ath11k_pci;
    /run/current-system/sw/bin/systemctl restart NetworkManager
  '';

  ##fix weird Lenovo Trackpoint issue (even present on Windows)
  #modules.resume.resumeScript = ''
  #  ${pkgs.kmod}/bin/modprobe -r psmouse && ${pkgs.kmod}/bin/modprobe psmouse;
  #'';

  services.cron.systemCronJobs = [
    "*/15 * * * * root ${pkgs.kmod}/bin/modprobe -r psmouse && ${pkgs.kmod}/bin/modprobe psmouse"
  ];
}
