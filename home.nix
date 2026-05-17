{ config, pkgs, vars, ... }:
{
  imports = [
    ./home/autostart.nix
    ./home/swayidle.nix
    ./home/niri-imports.nix
    ./home/outputscale.nix
    #./home/helix.nix
    ./home/kanshi.nix
    ./home/rclone.nix
    ./home/colors.nix
    ./home/wlrwhichkey.nix
  ];

  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  home.stateVersion = "${vars.system.stateVersion}";

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
  xdg.configFile."rofi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/rofi";
    recursive = true;
  };
  xdg.configFile."noctalia" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/noctalia";
    recursive = true;
  };

  xdg.configFile."remmina/remmina.pref" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/misc/remmina.pref";
    recursive = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      cat = "bat"; #like cat, but prettier
      ssh = "kitty +kitten ssh"; #fix "xterm-kitty: unknown terminal type"

      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --impure --flake ~/nixos";
      nru = "sudo nix flake update --flake ~/nixos && nrb";
      nrup = "sudo nix flake update --flake ~/nixos && nrb && sleep 60 && poweroff";
      ngd = "sudo nix-collect-garbage -d";

      nlg = "nixos-rebuild list-generations";

      vn = "nvim ~/nixos";
      hn = "hx ~/nixos";
      cn = "cd ~/nixos";

      ding = "ffplay -nodisp -autoexit ${vars.user.home}/nixos/home/winfin.mp3 > /dev/null 2>&1"; #command to put at end to signify when finished
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
      "application/pdf" = "org.gnome.Evince.desktop";
      #"application/epub+zip" = "org.gnome.Books.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/markdown" = "obsidian.desktop";
      
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
      "audio/mp4" = "audacious.desktop";
      "audio/flac" = "audacious.desktop";
     
      # Video
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      
      # Archives
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2" = "org.gnome.FileRoller.desktop";
      "application/x-gzip" = "org.gnome.FileRoller.desktop";
    };
  };
}
