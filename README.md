# nixos
Just a disclaimer, if you're trying to rebuild your entire system with this repo, don't. Some essential configurations are encrypted because of privacy reasons. I have this repo public for the specific purpose of having my different interesting modules be accessible to everyone and to have it be indexed by the internet for greater reach.

## Installation
1. ``nix-shell -p git git-crypt``
1. ``git clone https://github.com/tarzoq/nixos.git ~/nixos``
1. ``echo "BASE64-ENCODED GIT-CRYPT-KEY" | base64 -d > ~/git-crypt-key`` (created with: ``base64 "PASSPHRASE"``. Make sure to remove whitespaces!)
1. ``cd ~/nixos``
1. ``git-crypt unlock ~/git-crypt-key``
1. ``rm ~/git-crypt-key``
1. ``cp ~/nixos/variables.nix.template ~/nixos/variables.nix`` (adjust it to your needs)
1. ``sudo ln -s ~/nixos/variables.nix /etc/nixos/variables.nix`` (make it accessible by the flake, having it appear as being outside nix-store)
1. If new computer, copy ``host.nix.template`` in ``/hosts``, name it something appropriate (hostname), and tailor it for the computer you're installing it on.
1. ``sudo nixos-rebuild boot --impure --flake ~/nixos#HOSTNAME``
1. Reboot your computer and enjoy! 

#https://github.com/Frost-Phoenix/nixos-config/blob/main/README.md
| Component | Software |
| --- | :---: |
|Niri:|
| **Window Manager**          | niri |
| **Bar**                     | Noctalia |
| **Application Launcher**    | Vicinae |
| **Notification Daemon**     | Noctalia |
| **Terminal Emulator**       | Kitty |
| **Shell**                   | bash |
| **network management tool** | NetworkManager + Noctalia |
||
| **System resource monitor** | Mission Center + btop |
| **File Manager**            | Nemo (with Thunar Bulk Rename) |
| **Fonts**                   |  |
| **Color Scheme**            | Based on wallpaper |
| **GTK theme**               |  |
| **Cursor**                  | Apple-Cursor macOS |
| **Icons**                   | WhiteSur Dark |
| **Lockscreen**              | Hyprlock |
| **Idle Agent**              | Swayidle + Hypridle |
| **Image Viewer**            | Nomacs |
| **Media Player**            | mpv |
| **Music Player**            | Audacious |
| **Image Editor**     | GIMP |
| **Audio Editor**     | Audacity |
| **Video Editor**     | Davinci Resolve |
| **Screenshot Software**     | niri's built-in (or like Nick YT)|
| **Screen Recording**        | OBS Studio |
| **Clipboard**               | Vicinae |
| **Color Picker**            | Hyprpicker |
| **Email Client**            | Thunderbird |
| **Browser**            | Brave (perhaps origin in future?) |
| **VPN**            | ProtonVPN + Tailscale |
| **Messaging**            | Discord, Teams, Signal |
| **Gaming**            | Steam, Lutris, Heroic |
| **Online Storage**            | rclone |
| **Sheet Music Viewer**            | SheetMusicViewer |
||
|Bare Essentials:|
| **Clock & Timer**            | Gnome Clocks |
| **Notes**            | Obsidian |
| **Office Suite**            | OnlyOffice |
| **PDF Viewer**            | Okular |
| **Calculator**            | Gnome Calculator |
| **Text Editor**             | Gnome Text Editor |
| **Paint**            | Drawy |
| **Camera**                  | Cheese |
||
|Dev:|
| **Code Editor**             | Neovim + VSCode + Helix |
| **Docker Manager**            | lazydocker (TUI alternative to Docker Desktop) |
||
|Good to haves:|
| **Duplicate Finder**             | DupeGuru |
| **Sheet Music Editor**             | MuseScore? |
| **Media Writer**             | Ventoy, Impression, WoeUSB-ng |

On-screen Keyboard (tablet mode) = maliit-keyboard?

Goals:
Tablet mode
