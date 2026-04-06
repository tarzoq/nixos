{ config, pkgs, ... }:
let
  lock = "${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock &";
  suspend = "${pkgs.systemd}/bin/systemctl suspend";
  display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";

  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  lowerScreenAndKeyboard = "${brightnessctl} -s set 10 && ${brightnessctl} --device='*kbd_backlight' --save set 0"; #almost lowest
  restoreScreenAndKeyboard = "${brightnessctl} -r && ${brightnessctl} --device='*kbd_backlight' --restore"; #restore

  #status can be either "ac" or "bat"
  onPower = status: cmd: 
    let condition = if status == "ac" then "-eq 1" else "-ne 1";
    in "${pkgs.bash}/bin/bash -c '[[ \$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online) ${condition} ]] && ${cmd}'";
in {
  services.swayidle = {
    enable = true;
    timeouts = [
      ############ Lock (used for both) ###############
      {
        timeout = 5 * 60 - 5; # 5sec before lock
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 5 * 60;
        command = lock;
      }
      {
        timeout = 5 * 60 + 1 * 60; #1min after lock
	command = display "off";
      }

      ########### Battery #############
      { #screen backlight and keyboard
        timeout = builtins.floor (2.5 * 60); #otherwise results in float (NUMBER.0)
        command = onPower "ac" "${lowerScreenAndKeyboard}";
        resumeCommand = restoreScreenAndKeyboard;
      }
      { #screen off
        timeout = 5 * 60;
        command = onPower "bat" "${display "off"}";
	resumeCommand = "${display "on"}; ${restoreScreenAndKeyboard}";
      }
      { #suspend
        timeout = 10 * 60;
        command = onPower "bat" "${suspend}";
      }

      ############# AC ###############
      { #screen backlight and keyboard
        timeout = 15 * 60;
        #command = display "off";
        command = onPower "ac" "${lowerScreenAndKeyboard}";
        #resumeCommand = display "on";
        resumeCommand = restoreScreenAndKeyboard;
      }
      { #screen off
        timeout = 20 * 60;
        command = onPower "ac" "${display "off"}";
	resumeCommand = "${display "on"}; ${restoreScreenAndKeyboard}";
      }
      { #suspend
        timeout = 30 * 60;
        command = onPower "ac" "${suspend}";
      }
    ];
    events = { #standard events that make for example "loginctl lock-session" work, and intercept logind
      "before-sleep" = "${display "off"}; ${lock}";
      "after-resume" = "${display "on"}";
      #"lock" = "${display "off"}; ${lock}";
      "lock" = "${lock}";
      "unlock" = "${display "on"}";
    };
  };
}
