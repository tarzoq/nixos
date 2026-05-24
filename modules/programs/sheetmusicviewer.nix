{ config, pkgs, lib, vars, ... }:
#https://github.com/calvinhsia/SheetMusicViewer
let
  sheetMusicViewerBin = pkgs.stdenv.mkDerivation {
    pname = "sheet-music-viewer-bin";
    version = "1.017";

    src = pkgs.fetchurl {
      url = "https://github.com/calvinhsia/SheetMusicViewer/releases/download/v1.017/SheetMusicViewer-linux-x64.tar.gz";
      hash = "sha256:e31c82b70636970f9a28b7f6d975661eb197da8d45783e823868771e79d24271";
    };

    sourceRoot = ".";
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/bin/
      chmod +x $out/bin/SheetMusicViewer
    '';
  };
  sheetMusicViewer = pkgs.buildFHSEnv {
    name = "sheet-music-viewer";
    targetPkgs = pkgs: with pkgs; [
      sheetMusicViewerBin
      stdenv.cc.cc.lib
      libGL
      fontconfig
      libx11
      libxext
      libice
      libsm
      icu
    ];
    runScript = "${sheetMusicViewerBin}/bin/SheetMusicViewer";
    extraBwrapArgs = [
      "--unshare-net"
      #"--ro-bind \${HOME}/sheetmusic \${HOME}/sheetmusic"
      #"--tmpfs \${HOME}"
    ];
  };
in
{
  home-manager.users."${vars.user.name}" = {
    xdg.desktopEntries.sheet-music-viewer = {
      name = "Sheet Music Viewer";
      exec = "sheet-music-viewer";
      icon = "org.kde.okular";
      comment = "PDF sheet music viewer";
      categories = [ "AudioVideo" "Music" ];
      terminal = false;
    };

    home.packages = [ sheetMusicViewer ];
  };
}
