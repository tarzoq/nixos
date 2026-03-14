{ config, pkgs, ... }:

{
  #home-manager.users.${USER} = {
  #  home.stateVersion = "${stateVersion}";
  #  imports = [
  #    ./home/hyprland.nix
  #  ];
  #};

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      hrs = "home-manager --flake /etc/nixos switch; pkill waybar && waybar & disown";
    };
  };
  #programs.zsh.enable = true;
  
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   settings = {
  #     "$mod" = "SUPER";
  #     bind =
  #       [
  #         "$mod, F, exec, kitty"
  #         ", Print, exec, grimblast copy area"
  #       ]
  #       ++ (
  #         # workspaces
  #         # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
  #         builtins.concatLists (builtins.genList (i:
  #             let ws = i + 1;
  #             in [
  #               "$mod, code:1${toString i}, workspace, ${toString ws}"
  #               "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
  #             ]
  #           )
  #           9)
  #       );
  #   };
  # };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        { #screen backlight
          timeout = "150";                                # 2.5min.
          on-timeout = "brightnessctl -s set 10";         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r";                 # monitor backlight restore.
        }
        { #keyboard backlights
          timeout = "150";                                          # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
        }
        { #lock screen
          timeout = "300";                                 # 5min
          on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
        }
        { #screen off
          timeout = "330";                                                     # 5.5min
          on-timeout = "hyprctl dispatch dpms off";                            # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";          # screen on when activity is detected after timeout has fired.
        }
        { #suspend
          timeout = "1800";                                # 30min
          on-timeout = "systemctl suspend";                # suspend pc
        }
      ];
    };
  };
}
