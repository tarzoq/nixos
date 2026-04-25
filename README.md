# nixos
My personal NixOS config

## Installation
1. ``nix-shell -p git``
1. ``git clone https://github.com/tarzoq/nixos.git ~``
1. ``echo "base64 encoded git-crypt-key" | base64 -d > ~/git-crypt-key`` (``base64 git-crypt-key``, and remove whitespaces)
1. ``git-crypt unlock ~/git-crypt-key``
1. ``rm ~/git-crypt-key``
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
| **Notification Daemon**     | Noctalia |
| **Terminal Emulator**       | Kitty or Alacritty |
| **Shell**                   | bash |
| **Text Editor**             | Neovim or Helix + VSCode |
| **Camera**                  | Cheese + Snapshot |
| **network management tool** | NetworkManager + Noctalia |
| **System resource monitor** | Btop + Noctalia |
| **File Manager**            | Dolphin |
| **Fonts**                   |  |
| **Color Scheme**            | Wallpaper |
| **GTK theme**               |  |
| **Cursor**                  | Apple-Cursor macOS |
| **Icons**                   |  |
| **Lockscreen**              | Hyprlock |
| **Idle Agent**              | Swayidle + Hypridle |
| **Image Viewer**            | |
| **Media Player**            | mpv |
| **Music Player**            | audacious |
| **Screenshot Software**     | Niri's built-in |
| **Screen Recording**        | OBS Studio |
| **Clipboard**               | Noctalia plugin:clipper |
| **Color Picker**            | Hyprpicker |


Core:
Camera = snapshot
Image Viewer = nomacs
File Explorer = dolphin
Terminal = kitty or ghostty
Text Editor = gnome-text-editor
Paint = pinta
Calculator = gnome-calculator
Media Player = mpv / vlc
Email = thunderbird
Browser = brave
Office Suite = onlyoffice-desktopeditors
Task Manager = btop
Image Editing = gimp
Audio Editing = audacity
Video Editing = davinci resolve
Code Editor = vscode and nvim
VPN = protonvpn, tailscale
Messaging = discord, teams, signal



Calendar
Screenshot = Niri (or like Nick YT)

Clock & Timer

PDF Editor and Viewer = gnome document viewer? / okular




Music = Spotify



On-screen Keyboard (tablet mode) = maliit-keyboard?

Gaming:
steam
epicgames

Sheet Music:
librescore
Musescore

googledrive


Goals:
Tablet mode
