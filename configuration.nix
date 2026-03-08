# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let
  USER = "user";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./laptop.nix
      ./hibernate.nix
    ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  # networking.networkmanager.wifi.powersave = false;
  powerManagement.enable = true;

  security.polkit = {
    enable = true;
  };

  #powerManagement.powerDownCommands = ''
  #  /run/current-system/sw/bin/hyprlock
  #'';
  #
  #powerManagement.resumeCommands = ''
  #  /run/current-system/sw/bin/hyprlock
  #'';

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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
  services.xserver.enable = true;

  programs.hyprland = {
   enable = true;
   withUWSM = true; # recommended for most users
   xwayland.enable = true; # Xwayland can be disabled.
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
 
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

  programs.waybar = {
    enable = true;
  }; 

  #services.greetd = {
  #  enable = true;
  #  settings = {
  #    initial_session = {
  #      command = "uwsm start hyprland.desktop";
  #      user = "${USER}";
  #    };
  #    #mandatory fallback required by greetd
  #    default_session = {
  #      command = "uwsm start hyprland.desktop";
  #      user = "greeter";
  #    };
  #  };
  #};

  security.pam.services.hyprlock = {};
  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # remember Wi-Fi passwords
  services.gnome.gnome-keyring.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    gdm = {
      enable = true;
      wayland = true;
    };
    autoLogin = {
      enable = true;
      user = "${USER}";
    };
  };
  
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/start-hyprland";
      };
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
  programs.thunar.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/Fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    brave
    gimp
    vscode
    ffmpeg
    yt-dlp
    mpv #media player
    audacious #music player
    discord
    audacity
    fastfetch
    kitty # needed for hyprland
    psmisc # killall
    usbutils # lsusb
    lshw # hardwareinfo
    pciutils #lspci etc
    dmidecode
    ethtool
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    jq #json parser, required for zoom
    swayosd #OSD for volume and brightness
    hyprlock
    hypridle
    hyprpaper
    hyprsunset
    hyprpicker
    hyprpwcenter
    hyprshutdown
    hyprmon
    hyprcursor
    hyprpolkitagent
    hyprshot
    kanshi
    swaynotificationcenter
    #hyprlandPlugins.hyprspace
    # Else
    networkmanagerapplet
    pam_fde_boot_pw
    rofi
    brightnessctl
    playerctl
    btop
    cheese #camera
    # Dolphin KDE
    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse #to mount remote filesystems via FUSE
    kdePackages.kio-extras #extra protocols support (sftp, fish and more)
    kdePackages.qtsvg
    kdePackages.dolphin
  ];

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
