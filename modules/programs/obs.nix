{ config, pkgs, vars, ... }:
{
  #https://wiki.nixos.org/wiki/OBS_Studio
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };

  #modules.niri.imports = "include \"obs.hm.kdl\"";
  #home-manager.users."${vars.user.name}" = {
  #  home.file."nixos/config/niri/obs.hm.kdl". text = ''
  #    binds {
  #      Mod+KP_End { spawn-sh "niri msg action pass-keyboard-shortcuts --app-id com.obsproject.Studio"; }
  #      Mod+KP_Down { spawn-sh "niri msg action pass-keyboard-shortcuts --app-id com.obsproject.Studio"; }
  #    }
  #  '';
  #};
}
