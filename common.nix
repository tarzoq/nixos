{ config, lib, pkgs, vars, ... }:
#lutris
#gcdemu
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/niri.nix
    ./modules/noctalia.nix
    ./modules/programs/tailscale.nix
    ./modules/programs/chromium.nix
    ./modules/programs/virtualbox.nix
    ./modules/programs/nemo.nix
    ./modules/programs/obsidian.nix
    ./modules/programs/flatpak.nix
    ./modules/cursor.nix
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # force applications to use wayland
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal"; #not sure what this does, I'll have to look into it
    QT_STYLE_OVERRIDE = "gtk2";
  };

  nix.settings = {
    cores = 2;
    max-jobs = 2;
  };

  # good to haves to hardware support
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true; #fwupdmgr refresh; fwupdmgr get-updates; fwupdmgr update

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  # networking.networkmanager.wifi.powersave = false;
  powerManagement.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.warn-dirty = false;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  ##services.systembus-notify.enable = true;
  #environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ]; #if useUserPackages is enabled

  # Found somewhere on StackOverFlow
  services.keyd = { #keyd list-keys
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(meta, esc)"; # Capslock becomes Super, or Esc on tap
	    leftmeta = "layer(hyper)";
	    #super + altgr (mod5)?
          };
	  "hyper:M-G" = {}; #meta+rightalt/altgr (mod5) used for special keybinds in Niri since meta is already occupied by capslock
	  #"hyper:C-M-S-A" = {}; #fake HYPER-key (used for special keybinds in Niri)
        };
      };
    };
  };

  networking.hostName = "${vars.system.hostname}"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  #https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Needed to show battery charge
        FastConnectable = false; # Faster connects, however, more power consumption
      };
      Policy = {
        AutoEnable = true; # Enable all controllers when found
      };
    };
  };

  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "en_US.UTF-8";

  # run "locale" to view all fields
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  #https://wiki.nixos.org/wiki/OBS_Studio
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };

  #https://wiki.nixos.org/wiki/OpenRGB
  services.hardware.openrgb = { #motherboard (cpu-brand) shall be specified in host-config
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  security.polkit.enable = true;
  # remember Wi-Fi passwords
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  #services.dbus.packages = [ pkgs.gnome-keyring ];

  services.power-profiles-daemon.enable = false;
  services.upower.enable = true;

  ##https://wiki.nixos.org/wiki/Polkit
  #systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #  description = "polkit-gnome-authentication-agent-1";
  #  wantedBy = [ "graphical-session.target" ];
  #  wants = [ "graphical-session.target" ];
  #  after = [ "graphical-session.target" ];
  #  serviceConfig = {
  #    Type = "simple";
  #    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #    Restart = "on-failure";
  #    RestartSec = 1;
  #    TimeoutStopSec = 10;
  #  };
  #};

  #networking.nftables.enable #tailscale.nix
  #networking.firewall.enable #tailscale.nix

  services.displayManager = {
    gdm = {
      enable = true;
    };
    autoLogin = {
      enable = true;
      user = "${vars.user.name}";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-gnome 
    ];
    config = {
      common.default = lib.mkForce [ "gtk" ];
      niri.default = lib.mkForce [ "gnome" "gtk" ];
    };
  };

  # Configure keymap in X11 - only for X11?
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.dconf.enable = true; #needed for gtk-app settings

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "${vars.user.name}";
    extraGroups = [ "networkmanager" "wheel" "keyd" "video" "render" "input" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.kdeconnect.enable = true;
  programs.thunderbird.enable = true;

  # https://nixos.wiki/wiki/Fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  nixpkgs.config.allowUnfree = true;

  programs.evince.enable = true;
  environment.systemPackages = with pkgs; [
    zathura #might use in the future for sheet music (requires some additional touchscreen gesture tweaking)
    kdePackages.okular #pdf viewer
    ##############
    onlyoffice-desktopeditors #office suite
    gnome-text-editor #text editor
    nomacs #image viewer
    pinta #painter
    wget
    libinput
    bc #math in bash
    maliit-keyboard #on-screen keyboard for table mode
    comma #run programs without installing them
    git-crypt #encrypt specified personal folders and files automatically at commit
    git-filter-repo #rewrite git history
    tree #ls alternative
    bat #better looking cat
    tldr #better man
    neovim
    brave
    gimp
    ffmpeg
    yt-dlp
    mpv #media player
    vlc
    audacious #music player
    puddletag #mp3tag but better?
    discord
    signal-desktop #messaging
    proton-vpn
    audacity
    ############ DEV #############
    lazydocker
    ############ DEV #############
    fastfetch
    kitty #needed for hyprland
    ghostty #testing, unsure
    psmisc #killall
    usbutils #lsusb
    lshw #hardwareinfo
    pciutils #spci etc
    dmidecode #info about bios
    ethtool
    bind #nslookup etc.
    cmatrix #for fun
    pavucontrol #audio device settings
    #swayosd #OSD for volume and brightness
    #swaynotificationcenter
    libnotify
    # Else
    #cheese #camera
    stable.snapshot #camera
    gnome-calculator #calculator
    gnome-clocks #clock and timer
    hyprpicker #color picker and zoom
    rofi
    brightnessctl
    playerctl
    btop
    lsfg-vk
    lsfg-vk-ui
    spotify
    teams-for-linux
    polkit_gnome
    xeyes #troubleshoot xwayland
    unzip
    powertop #power draw statistics > https://youtu.be/GG4RzUBoLFs
    #(python3.withPackages (p: [ p.requests ])) #https://discourse.nixos.org/t/most-straightforward-way-to-install-python/67506/3
    nvtopPackages.full #graphics card task monitor, also works with .amd and .nvidia
    #gnome-firmware #frontend for fwupd
    #firmware-manager
    davinci-resolve #https://nixos.wiki/wiki/DaVinci_Resolve
    ############### SOFTWARE (tools) #########################
    stable.dupeguru #GUI duplicate file finder
    gparted-full
    ####### ISO ########
    #ventoy-full-gtk
    woeusb-ng #windows isos only
    impression #generic bootable media writer
    ####### ISO ########
  ];

  services.cron = {
    enable = true;
  };

  system.stateVersion = "${vars.system.stateVersion}";
}
