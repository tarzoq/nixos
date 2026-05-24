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
|Niri:
| **Window Manager**          | Niri |
| **Bar**                     | Noctalia |
| **Application Launcher**    | Rofi or Noctalia |
| **Notification Daemon**     | Noctalia |
| **Terminal Emulator**       | Kitty |
| **Shell**                   | bash |
| **network management tool** | NetworkManager + Noctalia |
|
| **System resource monitor** | Btop + Noctalia |
| **File Manager**            | Nemo (with Thunar Bulk Rename) |
| **Fonts**                   |  |
| **Color Scheme**            | Wallpaper |
| **GTK theme**               |  |
| **Cursor**                  | Apple-Cursor macOS |
| **Icons**                   |  |
| **Lockscreen**              | Hyprlock |
| **Idle Agent**              | Swayidle + Hypridle |
| **Image Viewer**            | Nomacs|
| **Media Player**            | VLC / mpv |
| **Music Player**            | Audacious |
| **Image Editor**     | GIMP |
| **Audio Editor**     | Audacity |
| **Video Editor**     | Davinci Resolve |
| **Screenshot Software**     | Niri's built-in (or like Nick YT)|
| **Screen Recording**        | OBS Studio |
| **Clipboard**               | Noctalia plugin:clipper |
| **Color Picker**            | Hyprpicker |
| **Email Client**            | Thunderbird |
| **Browser**            | Brave |
| **VPN**            | ProtonVPN + Tailscale |
| **Messaging**            | Discord, Teams, Signal |
| **Gaming**            | Steam, Lutris, Heroic |
| **Online Storage**            | Rclone |
| **Sheet Music Viewer**            | SheetMusicViewer |
|
|Bare Essentials:
| **Clock & Timer**            | Gnome Clocks |
| **Notes**            | Obsidian |
| **Office Suite**            | OnlyOffice |
| **PDF Viewer**            | Okular, Zathura |
| **Calculator**            | Gnome Calculator |
| **Text Editor**             | Gnome Text Editor |
| **Paint**            | Pinta |
| **Camera**                  | Snapshot or Cheese |
|
| Dev:
| **Code Editor**             | Neovim + VSCode (Helix?) |
| **Docker Manager**            | lazydocker (alternative to Docker Desktop) |
|
| Good to haves:
| **Duplicate Finder**             | DupeGuru |
| **Sheet Music Editor**             | MuseScore? |
| **Media Writer**             | Ventoy, Impression, WoeUSB-ng |

On-screen Keyboard (tablet mode) = maliit-keyboard?

Goals:
Tablet mode
