{ config, lib, pkgs, ... }:
let
  USER = "user";
  stateVersion = "25.11";
in {
  #options = with lib; with types; {
  #  tarzoq = mkOption { type = str; };
  #  age = mkOption { type = int; };
  #};
  #config = {
  #  tarzoq = "Yes, that is my alias";
  #  age = 21;
  #};
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      #./laptop.nix
      ./hosts/pc.nix
      #./hypr.nix
      ./niri.nix
      #./hibernate.nix
    ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  # networking.networkmanager.wifi.powersave = false;
  powerManagement.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  ## 1. Define the Path Unit
  #systemd.paths."watcher-home.nix" = {
  #  wantedBy = [ "multi-user.target" ];
  #  pathConfig = {
  #    PathChanged = "/etc/nixos/home.nix"; # Or PathExists, DirectoryNotEmpty, etc.
  #    Unit = "watcher-home.nix.service"; # The service to activate
  #  };
  #};

  ##2. Define the corresponding Service
  #systemd.services."watcher-home.nix" = {
  #  description = "Watch home.nix for changes";
  #  serviceConfig = {
  #    Type = "oneshot";
  #    User = "user";
  #    #ExecStart = "${pkgs.bash}/bin/bash -c '/run/current-system/sw/bin/brave' &"; 
  #    ExecStart = "${pkgs.bash}/bin/bash -c '/run/current-system/sw/bin/notify-send \"Home Manager\" \"Rebuild Done!\"'"; 
  #  };
  #  environment.DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus";
  #  unitConfig = {
  #    StartLimitBurst = 10;
  #    StartLimitIntervalSec = 60;
  #  };
  #};
  ##services.systembus-notify.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(meta, esc)"; # Example: capslock becomes Super, or Esc on tap
          };
        };
      };
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  #https://nixos.wiki/wiki/Bluetooth
  services.blueman.enable = true;
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

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;

  
 
  #programs.obs-studio = {
  #  enable = true;
  #  # optional Nvidia hardware acceleration
  #  package = (
  #    pkgs.obs-studio.override {
  #      cudaSupport = true;
  #    }
  #  );
  #  plugins = with pkgs.obs-studio-plugins; [
  #    wlrobs
  #    obs-backgroundremoval
  #    obs-pipewire-audio-capture
  #    obs-vaapi #optional AMD hardware acceleration
  #    obs-gstreamer
  #    obs-vkcapture
  #  ];
  #};

  programs.waybar.enable = true;

  #security.pam.services.hyprlock = {};
  #security.pam.services.hyprland.enableGnomeKeyring = true;

  # niri
  security.polkit.enable = true;
  # remember Wi-Fi passwords
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.gdm.enableGnomeKeyring = true;

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = ["gtk" ]; # or "kde"
  };

  services.displayManager = {
    #defaultSession = "hyprland-uwsm";
    gdm = {
      enable = true;
      wayland = true;
    };
    autoLogin = {
      enable = true;
      user = "${USER}";
    };
  };
  
 
  # services.displayManager.ly = {
  #   enable = true;
  #   settings = {
  #     animation = "matrix";
  #     hide_borders = true;
  #     clock = "%c";
  #     bigclock = true;
  #     hide_f1_commands = true;
  #   };
  # };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${USER} = {
    isNormalUser = true;
    description = "${USER}";
    extraGroups = [ "networkmanager" "wheel" "keyd" "video" "render" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.steam.enable = true;
  # Install firefox.
  #programs.firefox.enable = true;
  #programs.thunar.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    #config = {
    #  safe = { # needed for home-manager
    #  	directory = "/etc/nixos";
    #  };
    #};
  };

  # https://nixos.wiki/wiki/Fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pinta
    wget
    tree #ls alternative
    neovim
    gnome-text-editor
    brave
    gimp
    vscode
    ffmpeg
    yt-dlp
    mpv #media player
    audacious #music player
    discord
    protonvpn-gui
    audacity
    remmina
    fastfetch
    kitty # needed for hyprland
    psmisc # killall
    usbutils # lsusb
    lshw # hardwareinfo
    pciutils #lspci etc
    dmidecode
    ethtool
    cmatrix #for fun
    #libsForQt5.qt5.qtwayland
    #kdePackages.qtwayland
    pavucontrol #audio device settings
    #jq #json parser, required for zooming in and out
    swayosd #OSD for volume and brightness
    #hyprland
    # hyprlock
    # hypridle
    # hyprpaper
    # hyprsunset
    # hyprpicker
    # hyprpwcenter
    # hyprshutdown
    # hyprmon
    # hyprcursor
    # hyprpolkitagent
    # hyprshot
    # kanshi
    swaynotificationcenter
    libnotify
    #hyprlandPlugins.hyprspace
    # Else
    networkmanagerapplet
    #######pam_fde_boot_pw
    rofi
    brightnessctl
    playerctl
    btop
    #######guvcview #camera
    spotify
    teams-for-linux
    egl-wayland #needed for nvidia
    alacritty
    fuzzel
    swaylock
    mako
    swayidle
    xwayland-satellite
  ];

  services.tailscale.enable = true;
  #environment.systemPackages = pkgs.tail-tray;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${stateVersion}"; # Did you read the comment?

}
