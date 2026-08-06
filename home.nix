{ config, pkgs, vars, ... }:
let
  REPO = "~/nixos";
in
{
  imports = [
    ./home/idle.nix
    ./home/outputscale.nix
    ./home/helix.nix
    ./home/kanshi.nix
    ./home/rclone.nix
    ./home/dconf.nix
    ./home/exec-desktop.nix
  ];

  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  home.stateVersion = "${vars.system.stateVersion}";
  home.enableNixpkgsReleaseCheck = false; #disable mismatched version warning, I'm using nixpkgs.follows anyway.

  ##wallpapers: https://github.com/5hubham5ingh/WallRizz/tree/wallpapers
  #home.file."Pictures/Wallpapers/WallRizz" = {
  #  source = builtins.fetchGit {
  #    url = "https://github.com/5hubham5ingh/WallRizz";
  #    ref = "wallpapers";
  #      rev = "ff3db3bd13042dfca29b4629fac62e3a2a3289e2";
  #  };
  #  recursive = true;
  #};

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/niri";
    recursive = true;
  };
  xdg.configFile."kanshi/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/kanshi";
    recursive = true;
  };

  xdg.configFile."hypr/hyprland.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/hypr/hyprland.conf";
    recursive = true;
  };
  xdg.configFile."hypr/hyprlock.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/hypr/hyprlock.conf";
    recursive = true;
  };

  xdg.configFile."kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/kitty";
    recursive = true;
  };
  home.file.".local/state/noctalia" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/noctalia";
    recursive = true;
  };
  xdg.configFile."vicinae" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/vicinae";
    recursive = true;
  };

  xdg.configFile."remmina/remmina.pref" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/misc/remmina.pref";
    recursive = true;
  };
  xdg.configFile."Proton/VPN" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/misc/protonvpn";
    recursive = true;
  };
  xdg.configFile."puddletag" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/misc/puddletag";
    recursive = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      cat = "bat"; #like cat, but prettier
      v = "nvim"; #editor of choice
      ssh = "kitty +kitten ssh"; #fix "xterm-kitty: unknown terminal type"

      #nrs = "sudo true && nh os switch --impure ${REPO} --accept-flake-config";
      nrs = "sudo nixos-rebuild switch --impure --flake ${REPO}";
      #nrb = "sudo true && nh os boot --impure ${REPO} --accept-flake-config";
      nrb = "sudo nixos-rebuild boot --impure --flake ${REPO}";
      nrbp = "sudo nixos-rebuild boot --impure --flake ${REPO} && sleep 60 && poweroff";
      #nru = "sudo nix flake update --flake ${REPO} && nrb";
      nru = "sudo nix flake update --flake ${REPO} && nrb";
      #nrup = "nru && sleep 60 && poweroff";
      nrup = "nru && sleep 60 && poweroff";

      #ns = "nh search"; #search nixpkgs with nh

      #ngd = "sudo true && nh clean all";
      ngd = "sudo nix-collect-garbage -d";
      nlg = "nixos-rebuild list-generations";

      vn = "nvim ${REPO}";
      hn = "hx ${REPO}";
      h = "hx";
      cn = "cd ${REPO}";

      ding = "ffplay -nodisp -autoexit ${vars.user.home}/nixos/home/sfx/winfin.mp3 > /dev/null 2>&1"; #command to put at end to signify when finished

      ########### GIT ##############
      gpf = "git -C ${REPO} fetch";
      gpp = "git -C ${REPO} pull";
      gpu = "git -C ${REPO} push";
      gps = "git -C ${REPO} status";
      gpo = "git -C ${REPO} show";
      gpd = "git -C ${REPO} diff";
      rnru = "git -C ${REPO} restore flake.lock"; #revert flake.lock in case of failed update
    };
  };

  services.remmina = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs; #FHS-compliance
    mutableExtensionsDir = true; #allows for imperative extensions
  };
  home.file.".vscode/argv.json".text = builtins.toJSON {
    "password-store" = "gnome-libsecret";
  };

  #https://nixos.wiki/wiki/Git
  programs.git = {
    enable = true;
    #config = {
    #  safe = { # needed for home-manager
    #  	directory = "/etc/nixos";
    #  };
    #};
    settings = {
      user = {
        name = "${vars.user.alias}";
        email = "${vars.user.email}";
      };
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  xdg.userDirs = {
    enable = true;
    setSessionVariables = false;
    createDirectories = true;
  };
  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = { #ls /run/current-system/sw/share/applications/
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";

      # Documents
      "application/pdf" = "org.kde.okular.desktop";
      #"application/epub+zip" = "org.gnome.Books.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/markdown" = "org.gnome.TextEditor.desktop";
      
      # Office Suite
      "application/msword" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice-desktopeditors.desktop";
      
      # Directories / File Transfers
      #"inode/directory" = "org.gnome.Nautilus.desktop";
      "x-scheme-handler/ftp" = "brave-browser.desktop";
      
      # Images
      "image/jpeg" = "org.nomacs.ImageLounge.desktop";
      "image/png" = "org.nomacs.ImageLounge.desktop";
      "image/gif" = "org.nomacs.ImageLounge.desktop";
      "image/webp" = "org.nomacs.ImageLounge.desktop";
      "image/svg+xml" = "org.nomacs.ImageLounge.desktop";
     
      # Audio
      "audio/mpeg" = "audacious.desktop";
      "audio/ogg" = "audacious.desktop";
      "audio/vorbis" = "audacious.desktop";
      "audio/mp4" = "audacious.desktop";
      "audio/flac" = "audacious.desktop";
      "audio/vnd.wave" = "audacious.desktop";
      "audio/3gpp" = "audacious.desktop";
     
      # Video
      "video/mp4" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      
      # Archives
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2" = "org.gnome.FileRoller.desktop";
      "application/x-gzip" = "org.gnome.FileRoller.desktop";
    };
  };
}
