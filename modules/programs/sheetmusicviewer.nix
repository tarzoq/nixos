{ config, pkgs, lib, vars, ... }:
#https://github.com/calvinhsia/SheetMusicViewer
let
  sheetMusicViewerBin = pkgs.stdenv.mkDerivation {
    pname = "sheet-music-viewer-bin";
    version = "1.018";

    src = pkgs.fetchurl {
      url = "https://github.com/calvinhsia/SheetMusicViewer/releases/download/v1.018/SheetMusicViewer-linux-x64.tar.gz";
      hash = "sha256:4d2d3e4b921e69162323ef3283b4c2a52e6f91df63b20baa1cfd4c19ebc37656";
    };

    sourceRoot = ".";
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/bin/
      chmod +x $out/bin/SheetMusicViewer
    '';
  };
  cursorName = config.home-manager.users."${vars.user.name}".home.pointerCursor.name;
  cursorSize = toString config.home-manager.users."${vars.user.name}".home.pointerCursor.size;
  cursorPackage = config.home-manager.users."${vars.user.name}".home.pointerCursor.package;
in
  let
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
        #"--ro-bind \${HOME}/sheetmusic \${HOME}/sheetmusic"
        #"--tmpfs \${HOME}"
        "--unshare-net"
        "--setenv XCURSOR_PATH ${vars.user.home}/.icons"
        "--setenv XCURSOR_THEME ${cursorName}"
        "--setenv XCURSOR_SIZE ${cursorSize}"
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
