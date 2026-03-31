{ config, pkgs, ... }:

{
  # boot.kernelParams = [ "nvidia-drm.modeset=1" ]; #suggested by ai, not found anywhere else, didn't change anything when I tried it
  #https://wiki.nixos.org/wiki/NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true; #required for wayland
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.prime = {
    reverseSync.enable = true;
    nvidiaBusId = "PCI:1@0:0:0"; #lspci -D -d ::03xx
    amdgpuBusId = "PCI:16@0:0:0"; #hexadecimal to decimal
  };
  hardware.nvidia.powerManagement.enable = true; #attempt to fix problem with suspend
  #systemd.paths."watcher-home.nix" = {
  #  wantedBy = [ "multi-user.target" ];
  #  pathConfig = {
  #    PathChanged = "/etc/nixos/home.nix"; # Or PathExists, DirectoryNotEmpty, etc.
  #    Unit = "watcher-home.nix.service"; # The service to activate
  #  };
  #};
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb-with-all-plugins;
  };
  #programs.dconf.profiles.gdm.databases = [{ #https://discourse.nixos.org/t/how-to-enable-numlock-in-configuration-nix/24618/13
  #  settings."org/gnome/desktop/peripherals/keyboard" = {
  #    numlock-state = true;
  #  };
  #}];
  environment.systemPackages = with pkgs; [
    egl-wayland #needed for nvidia
    #nvtopPackages.nvidia #or full for all 
  ];
}
