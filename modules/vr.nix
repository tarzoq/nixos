#https://www.reddit.com/r/OculusQuest/comments/1inmstk/alvr_now_has_a_wired_mode_toggle/#:~:text=With%20the%20newest%20version%20of,a%20pretty%20easy%20setup%20though.

#ALVR in wired mode over ADB. Requires developer mode on headset

#Use Immersed over wired, and have niri create virtual monitor when headset is plugged in: niri msg action create-virtual-output
{ config, pkgs, ... }:
{
  programs.immersed.enable = true;
}
