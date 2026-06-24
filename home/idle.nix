{ config, pkgs, ... }:
let
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  pidof = "${pkgs.procps}/bin/pidof";

  offScreenIfLocked = "${pidof} hyprlock && ${display "off"}"; #turn screen off if hyprlock is running
   
  lock = "${pidof} hyprlock || ${hyprlock} &"; #only run hyprlock if hyprlock isn't already running
  suspend = "${pkgs.systemd}/bin/systemctl suspend";
  display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";

  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  lowerScreen = "${brightnessctl} -s set 10"; #almost lowest
  lowerKeyboard = "${brightnessctl} --device='*kbd_backlight' --save set 0";
  restoreScreen = "${brightnessctl} -r"; #restore
  restoreKeyboard = "${brightnessctl} --device='*kbd_backlight' --restore"; #restore

  #status can be either "ac" or "bat"
  onPower = status: cmd: 
    let condition = if status == "bat" then "-eq 1" else "-ne 1";
    in "${pkgs.bash}/bin/bash -c '[[ $(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online) ${condition} ]] || ${cmd}'";

  #only runs consecutive command (notHibernating && ...) if system isn't hibernating. This since I have FDE, where I want autologin directly, unlike normal suspend.
  #notHibernating = pkgs.writeShellScript "not-hibernating" ''
  #  if ${pkgs.systemd}/bin/systemctl is-active --quiet hibernate.target; then
  #    exit 1
  #  else
  #    exit 0 
  #  fi
  #'';
  #lockIfNotHibernate = "${pkgs.bash}/bin/bash -c '${pkgs.systemd}/bin/systemctl is-active --quiet hibernate.target && exit; ${lock}'";
in {
  ############################## keyboard only (ignores inhibitors) ################################
  services.hypridle = { 
    enable = true;
    settings = {
      general = { #options needed to ignore inhibition
        ignore_dbus_inhibit = true;
	ignore_systemd_inhibit = true;
	ignore_wayland_inhibit = true;
      };
      listener = [
        { ######### KBD Racklight - Battery ############
          timeout = "${toString (1 * 60)}";
          on-timeout = "${onPower "bat" "${lowerKeyboard}"}";
          on-resume = "${restoreKeyboard}";
        }
        { ######### KBD Backlight - AC #############
          timeout = "${toString (2 * 60)}";
          on-timeout = "${onPower "ac" "${lowerKeyboard}"}";
          on-resume = "${restoreKeyboard}";
        }
      ];
    };
  };
  ########################## everything else (screen, lock, suspend) ################################
  services.swayidle = { 
    enable = true;
    timeouts = [
      ########### Battery #############
      { #screen backlight
        timeout = builtins.floor (2.5 * 60); #otherwise results in float (NUMBER.0)
        command = onPower "bat" "${lowerScreen}";
        resumeCommand = restoreScreen;
      }
      { #reminder screen locking in 5 sec
        timeout = 3 * 60 - 5; # 5sec before lock
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      { #lock screen
        timeout = 3 * 60;
        command = lock;
      }
      { #screen off
        timeout = 5 * 60;
        command = onPower "bat" "${display "off"}";
	resumeCommand = "${display "on"}"; #should not require restoreScreen and Keyboard, since that is already done by the other resumesCommands
      }
      { #suspend
        timeout = 10 * 60;
        command = onPower "bat" "${suspend}";
      }

      ############# AC ###############
      { #screen backlight
        timeout = builtins.floor (9.5 * 60);
        command = onPower "ac" "${lowerScreen}";
        resumeCommand = restoreScreen;
      }
      { #reminder screen locking in 5 sec
        timeout = 10 * 60 - 5; # 5sec before lock
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      { #lock screen
        timeout = 10 * 60;
        command = lock;
      }
      { #screen off
        timeout = 11 * 60;
        command = onPower "ac" "${display "off"}";
	resumeCommand = "${display "on"}";
      }
      { #suspend
        #timeout = 20 * 60;
        timeout = 50 * 60;
        command = onPower "ac" "${suspend}";
      }

      ############ Lock (used for both) ###############
      {
        timeout = 1 * 60; #1min after lock, only turns off screen lock is manually triggered
	command = offScreenIfLocked;
      }
    ];
    events = { #standard events that make for example "loginctl lock-session" work, and intercept logind
      "before-sleep" = "${display "off"}; ${lock}";
      "after-resume" = "${display "on"}";
      "lock" = "${lock}";
      "unlock" = "${display "on"}";
    };
  };
}
