{ config, pkgs, ... }:
#install Lossless Scaling through Steam first!
#currently needs ENABLE_LSFG=1 passed as an argument to an application that renders using Vulkan.
#my goal initially was to be able to use this with my browser and through a keybind enable LSFG. This worked just fine on Windows, but it appears to only so far be a requested feature for Linux. So for now I have to pump the brakes on this.
{
  environment.systemPackages = with pkgs; [
    lsfg-vk #lossless scaling
    lsfg-vk-ui #lossless scaling
  ]:
}
