{ config, pkgs, vars, ... }:
{
  imports = [
    ./home/autostart.nix
    #./home/hyprlock.nix
    ./home/swayidle.nix
    ./home/cursor.nix
    ./home/niri-imports.nix
    #./home/helix.nix
  ];

  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  home.stateVersion = "${vars.system.stateVersion}";
  #xdg.portal = {
  #  enable = true;
  #  extraPortals = [ xdg.desktop-portal-kde ];
  #};
  #xdg.enable = true;

  ##wallpapers: https://github.com/5hubham5ingh/WallRizz/tree/wallpapers
  #home.file."Pictures/Wallpapers/WallRizz" = {
  #  source = builtins.fetchGit {
  #    url = "https://github.com/5hubham5ingh/WallRizz";
  #    ref = "wallpapers";
  #      rev = "ff3db3bd13042dfca29b4629fac62e3a2a3289e2";
  #  };
  #  recursive = true;
  #};

  xdg.configFile."hypr/hyprland.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/hypr/hyprland.conf";
    recursive = true;
  };
  xdg.configFile."hypr/hyprlock.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/hypr/hyprlock.conf";
    recursive = true;
  };
  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/config/niri";
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

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      cat = "bat"; #like cat, but prettier

      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --impure --flake ~/nixos";
      nru = "sudo nix flake update --flake ~/nixos && nrb";
      nrup = "sudo nix flake update --flake ~/nixos && nrb && sleep 60 && poweroff";

      nlg = "nixos-rebuild list-generations";

      vn = "nvim ~/nixos";
      hn = "hx ~/nixos";
      cn = "cd ~/nixos";

      ding = "ffplay -nodisp -autoexit ${vars.user.home}/nixos/home/stash/winfin.mp3 > /dev/null 2>&1"; #command to put at end to signify when finished
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
}
