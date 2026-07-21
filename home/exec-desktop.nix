{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.puddletag.overrideAttrs (oldAttrs: { #start puddletag with env xcb (solve issue with drag and drop windows)
      postFixup = (oldAttrs.postFixup or "") + ''
        substituteInPlace $out/share/applications/puddletag.desktop \
          --replace-fail 'Exec=puddletag %F' 'Exec=env QT_QPA_PLATFORM=xcb puddletag'
      '';
    }))
  ];
}
