{ config, pkgs, vars, ... }:
{
  imports = [
    ./modules/autostart.nix
    #./hm/hypridle.nix
    ./hm/swayidle.nix
    ./hm/cursor.nix
  ];

  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  home.stateVersion = "${vars.system.stateVersion}";

  #wallpapers: https://github.com/5hubham5ingh/WallRizz/tree/wallpapers
  home.file."Pictures/Wallpapers/WallRizz" = {
    source = builtins.fetchGit {
      url = "https://github.com/5hubham5ingh/WallRizz";
      ref = "wallpapers";
        rev = "ff3db3bd13042dfca29b4629fac62e3a2a3289e2";
    };
    recursive = true;
  };

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/dotfiles/hypr";
    recursive = true;
  };

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/dotfiles/niri";
    recursive = true;
  };

  xdg.configFile."kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/dotfiles/kitty";
    recursive = true;
  };
  xdg.configFile."rofi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vars.user.home}/nixos/dotfiles/rofi";
    recursive = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";

      nrs = "sudo nixos-rebuild switch --impure --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --impure --flake ~/nixos";
      nru = "sudo nix flake update --flake ~/nixos && nrb";
      nrup = "sudo nix flake update --flake ~/nixos && nrb && sleep 60 && poweroff";

      nlg = "nixos-rebuild list-generations";

      vn = "nvim ~/nixos";
      cn = "cd ~/nixos";
    };
  };
  
  services.remmina = {
    enable = true;
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
