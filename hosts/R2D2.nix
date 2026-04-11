{ config, pkgs, inputs, ... }:
{
  imports =
    [
      # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4

      ../common.nix
      ../modules/hibernate.nix
    ];
  modules.hibernate.resumeOffset = 65572864;
  modules.hibernate.diskUuid = "253b6ad1-b80b-4441-9081-4e2f54a17782";
  modules.hibernate.ramGb = 32;
  modules.hibernate.hibernateScript = "/run/current-system/sw/bin/modprobe -r ath11k_pci";
  modules.hibernate.resumeScript = "/run/current-system/sw/bin/modprobe ath11k_pci";

  #https://nixos.wiki/wiki/Laptop
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 100; 
      };
  };
}
