{ config, pkgs, ... }:
{
  #https://wiki.nixos.org/wiki/AMDGPU
  environment.variables.AMD_VULKAN_ICD = "RADV";

  #boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.amdgpu.opencl.enable = true;

  #hardware.graphics.extraPackages = with pkgs; [
  #  rocmPackages.clr.icd #opencl
  #  #amdvlk #amdvlk drivers, in addition to Mesa RADV
  #];

  #hardware.graphics.extraPackages32 = with pkgs; [
  #  rocmPackages.clr.icd #opencl
  #  #driversi686Linux.amdvlk
  #];
}
