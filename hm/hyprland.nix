{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "pkill rofi || rofi -show drun";
      "$taskManager" = "kitty -e btop";
      "$browser" = "brave";

      "$mod" = "SUPER";
      bind = # normal binds
        [
          "$mod, return, exec, $terminal" 
          "$mod, Q, killactive" 
          "$mod, M, exit" 
          "$mod, E, exec, $fileManager" 
          "$mod, B, exec, $browser" 
          "$mod, V, togglefloating" 
          "$mod, W, exec, $menu" 
          "$mod, L, exec, loginctl lock-session" 
          "ALT, Return, fullscreen" 

          "CTRL ALT, Delete, exec, hyprshutdown --post-cmd 'poweroff'" 


          # moving focus
          "$mod, H, movefocus, l" 
          "$mod, L, movefocus, r" 
          "$mod, K, movefocus, u" 
          "$mod, J, movefocus, d" 

	  # numbered workspaces
          "$mod, 1, workspace, 1" 
          "$mod, 2, workspace, 2" 
          "$mod, 3, workspace, 3" 
          "$mod, 4, workspace, 4" 
          "$mod, 5, workspace, 5" 
          "$mod, 6, workspace, 6" 
          "$mod, 7, workspace, 7" 
          "$mod, 8, workspace, 8" 
          "$mod, 9, workspace, 9" 
          "$mod, 0, workspace, 10" 
          "$mod SHIFT, 1, movetoworkspace, 1" 
          "$mod SHIFT, 2, movetoworkspace, 2" 
          "$mod SHIFT, 3, movetoworkspace, 3" 
          "$mod SHIFT, 4, movetoworkspace, 4" 
          "$mod SHIFT, 5, movetoworkspace, 5" 
          "$mod SHIFT, 6, movetoworkspace, 6" 
          "$mod SHIFT, 7, movetoworkspace, 7" 
          "$mod SHIFT, 8, movetoworkspace, 8" 
          "$mod SHIFT, 9, movetoworkspace, 9" 
          "$mod SHIFT, 0, movetoworkspace, 10" 

          # left and right
          "$mod, D, workspace, -1" 
          "$mod, F, workspace, +1" 
          "$mod SHIFT, D, movetoworkspace, -1" 
          "$mod SHIFT, F, movetoworkspace, +1" 
          "$mod, mouse_up, workspace, e-1" 
          "$mod, mouse_down, workspace, e+1" 

          # zooming
	  "$mod, plus, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.4')" 
	  "$mod, minus, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.6') | if . < 1 then 1 else . end')" 

          # window management 
          "$mod, mouse:272, movewindow" 
          "$mod, mouse:273, resizewindow" 







          #", Print, exec, grimblast copy area"
        ];
	bindel = [ # exclusive and locked binds
	  #https://github.com/ErikReider/SwayOSD
          ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

          ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
	  
          ",XF86AudioPause, exec, swayosd-client --playerctl play-pause"
          ",XF86AudioPlay, exec, swayosd-client --playerctl play-pause"
          ",XF86AudioPrev, exec, swayosd-client --playerctl previous"
          ",XF86AudioNext, exec, swayosd-client --playerctl next"
	];
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}





#bind	Normal keybinding	Most keyboard shortcuts
#bindm	Mouse binding	Dragging, resizing, moving windows
#bindl	Locked keybinding	Works even when a key is held down
#bindel	Exclusive locked binding	For media keys, volume keys, brightness keys
#bindr	Release binding	Trigger when key is released
#bindle	Locked + repeat	For keys that should repeat while held
#binde	Exclusive	Prevents other binds from interfering
