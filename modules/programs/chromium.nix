{ config, pkgs, vars, ... }:
{
  programs.chromium = {
    enable = true;
    homepageLocation = "${vars.misc.browserHomepage}";
    #https://discourse.nixos.org/t/is-there-a-way-to-force-disable-private-window-with-tor-from-brave-at-installation-time/74920
    #extensions = [
    #  "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    #];
    extraOpts = {
      "RestoreOnStartup" = 1; # 1 = Load a specific URL
      "RestoreOnStartupURLs" = [ "${vars.misc.browserHomepage}" ];
      "NewTabPageLocation" = "${vars.misc.browserHomepage}"; # Specific to new tabs
      #https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy
      "TorDisabled" = true;
      "BraveRewardsDisabled" = true;
      "BraveWalletDisabled" = true;
      "BraveVPNDisabled" = true;
      "BraveAIChatEnabled" = false;
      "BraveNewsDisabled" = true;
      "BraveTalkDisabled" = true;
      "BraveWebDiscoveryEnabled" = false;
    };
  };
  environment.systemPackages = with pkgs; [
    (brave.override {
      commandLineArgs = [ #enable vulkan etc.
	"--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs"
	#"--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        #"--enable-features=VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        "--ignore-gpu-blocklist" #webgpu interop
        "--enable-zero-copy"
      ];
    })
  ];
}
