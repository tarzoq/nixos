# nixos
My personal NixOS config

## Installation
1. ``nix-shell -p git``
1. ``git clone https://github.com/tarzoq/nixos.git ~``
1. ``cp ~/nixos/variables.nix.template ~/nixos/variables.nix`` (adjust it to your needs)
1. ``sudo ln -s ~/nixos/variables.nix /etc/nixos/variables.nix``
1. If new computer, copy ``host.nix.template`` in ``/hosts``, name it something appropriate (hostname), and tailor it for the computer you're installing it on.
1. ``sudo nixos-rebuild boot --impure --flake ~/nixos#HOSTNAME``

#https://github.com/Frost-Phoenix/nixos-config/blob/main/README.md
| Component | Software |
| --- | :---: |
| **Window Manager**          | Niri |
| **Bar**                     | Noctalia |
| **Application Launcher**    | Rofi or Noctalia |
| **Notification Daemon**     | Mako or Noctalia |
| **Terminal Emulator**       | Kitty or Alacritty |
| **Shell**                   | bash |
| **Text Editor**             | Neovim or Helix + VSCode |
| **Camera**                  | Cheese |
| **network management tool** | NetworkManager + Noctalia |
| **System resource monitor** | Btop + Noctalia |
| **File Manager**            | Dolphin |
| **Fonts**                   |  |
| **Color Scheme**            | Wallpaper |
| **GTK theme**               |  |
| **Cursor**                  | Apple-Cursor macOS |
| **Icons**                   |  |
| **Lockscreen**              | Hyprlock |
| **Idle Agent**              | Swayidle |
| **Image Viewer**            | |
| **Media Player**            | mpv |
| **Music Player**            | audacious |
| **Screenshot Software**     | Niri's built-in |
| **Screen Recording**        | OBS Studio |
| **Clipboard**               | Noctalia |
| **Color Picker**            |  |
