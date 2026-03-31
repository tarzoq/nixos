{ config, lib, pkgs, ... }:
let
  USER = "user";
  stateVersion = "25.11";
in {
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./hypr.nix
      #./niri.nix
      #./hosts/laptop.nix
      ./hosts/pc.nix
    ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # force applications to use wayland

  programs.dms-shell.enable = true; #dankmaterialshell

  # good to haves to hardware support
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Bootloader.
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

  # Found somewhere on StackOverFlow
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(meta, esc)"; # Capslock becomes Super, or Esc on tap
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

  
 
  programs.obs-studio = {
    enable = true;
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

  #programs.waybar.enable = true;

  security.pam.services.hyprlock = {};

  # niri
  security.polkit.enable = true;
  # remember Wi-Fi passwords
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # noctalia
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  #https://wiki.nixos.org/wiki/Polkit
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.displayManager = {
    gdm = {
      # default session for hyprland: hyprland-uwsm
      enable = true;
      wayland = true;
    };
    autoLogin = {
      enable = true;
      user = "${USER}";
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
  #programs.thunar.enable = true;

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


  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run: $ nix search wget
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
    proton-vpn
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
    pavucontrol #audio device settings
    swayosd #OSD for volume and brightness
    hyprlock
    swaynotificationcenter
    libnotify
    # Else
    networkmanagerapplet
    rofi
    brightnessctl
    playerctl
    btop
    spotify
    teams-for-linux
    nautilus
    polkit_gnome
  ];

  services.tailscale.enable = true;
  #environment.systemPackages = pkgs.tail-tray;

  system.stateVersion = "${stateVersion}";
}
