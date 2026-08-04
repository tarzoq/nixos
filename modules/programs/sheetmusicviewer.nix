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
    credentialsFile = "${vars.user.home}/nixos/config/misc/sheetmusicviewer/webdav.env";
    rcloneMountPath = "${vars.user.home}/.cache/sheetmusic/webdav";
    mergedPath = "${vars.user.home}/.cache/sheetmusic/merged";
    upperPath = "${vars.user.home}/.cache/sheetmusic/upper";
    workPath = "${vars.user.home}/.cache/sheetmusic/work";

    sheetMusicViewerApp = pkgs.buildFHSEnv {
      name = "sheet-music-viewer-app";
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
	"--bind ${mergedPath} ${vars.user.home}/sheetmusic"
        "--unshare-net"
        "--setenv XCURSOR_PATH ${vars.user.home}/.icons"
        "--setenv XCURSOR_THEME ${cursorName}"
        "--setenv XCURSOR_SIZE ${cursorSize}"
      ];
    };

    sheetMusicViewer = pkgs.writeShellScriptBin "sheet-music-viewer" ''
      set -e
      CRED_FILE="${credentialsFile}"
      RCLONE_MOUNT="${rcloneMountPath}"
      MERGED="${mergedPath}"

      # shellcheck disable=SC1090
      . "$CRED_FILE"

      mkdir -p "$RCLONE_MOUNT" "${upperPath}" "${workPath}" "$MERGED"

      STARTED_RCLONE=0
      if ! ${pkgs.util-linux}/bin/mountpoint -q "$RCLONE_MOUNT"; then
        ${pkgs.rclone}/bin/rclone mount ":webdav:" "$RCLONE_MOUNT" \
          --webdav-url="$WEBDAV_URL" \
          --webdav-user="$WEBDAV_USER" \
          --webdav-pass="$WEBDAV_PASS" \
          --webdav-vendor=owncloud \
          --daemon --daemon-wait=10 \
          --vfs-cache-mode=minimal \
          --read-only
        STARTED_RCLONE=1
      fi

      STARTED_OVERLAY=0
      if ! ${pkgs.util-linux}/bin/mountpoint -q "$MERGED"; then
        ${pkgs.fuse-overlayfs}/bin/fuse-overlayfs \
          -o lowerdir="$RCLONE_MOUNT",upperdir="${upperPath}",workdir="${workPath}" \
          "$MERGED"
        STARTED_OVERLAY=1
      fi

      #umounts after exit or crash
      cleanup() {
        [ "$STARTED_OVERLAY" = "1" ] && /run/wrappers/bin/fusermount3 -uz "$MERGED"
        [ "$STARTED_RCLONE" = "1" ] && /run/wrappers/bin/fusermount3 -uz "$RCLONE_MOUNT"
      }
      trap cleanup EXIT INT TERM

      ${sheetMusicViewerApp}/bin/sheet-music-viewer-app
    '';
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
    home.packages = [
      sheetMusicViewer
      pkgs.rclone
      pkgs.fuse-overlayfs
      pkgs.fuse3
    ];
  };
}
