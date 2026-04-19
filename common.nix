{ config, lib, pkgs, vars, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    #./modules/hypr.nix
    ./modules/niri.nix
    ./modules/noctalia.nix
    #./modules/stylix.nix
    ./modules/programs/tailscale.nix
    ./modules/programs/thunar.nix
    ./modules/programs/dolphin.nix
    ./modules/programs/chromium.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # force applications to use wayland

  #programs.dms-shell.enable = true; #dankmaterialshell

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
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(meta, esc)"; # Capslock becomes Super, or Esc on tap
	    leftmeta = "layer(hyper)";
          };
	  "hyper:C-M-S-A" = {}; #fake HYPER-key (used for special keybinds in Niri)
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

  #https://wiki.nixos.org/wiki/OBS_Studio
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
  programs.obs-studio.enableVirtualCamera = true;

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

  # noctalia
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
      # default session for hyprland: hyprland-uwsm
      enable = true;
      wayland = true;
    };
    autoLogin = {
      enable = true;
      user = "${vars.user.name}";
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
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "${vars.user.name}";
    extraGroups = [ "networkmanager" "wheel" "keyd" "video" "render" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.kdeconnect.enable = true;

  # https://nixos.wiki/wiki/Fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    pinta #painter
    wget
    comma #run programs without installing them
    tree #ls alternative
    bat #better looking cat
    neovim
    brave
    gimp
    ffmpeg
    yt-dlp
    mpv #media player
    audacious #music player
    puddletag #mp3tag but better?
    discord
    proton-vpn
    audacity
    fastfetch
    kitty #needed for hyprland
    psmisc #killall
    usbutils #lsusb
    lshw #hardwareinfo
    pciutils #spci etc
    dmidecode #info about bios
    ethtool
    cmatrix #for fun
    pavucontrol #audio device settings
    #swayosd #OSD for volume and brightness
    #swaynotificationcenter
    libnotify
    # Else
    cheese #camera
    kdePackages.kate #notes
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
    #nemo-with-extensions #https://wiki.nixos.org/wiki/Nemo
    kdePackages.okular #pdf viewer
    #(python3.withPackages (p: [ p.requests ])) #https://discourse.nixos.org/t/most-straightforward-way-to-install-python/67506/3
    nvtopPackages.full #graphics card task monitor, also works with .amd and .nvidia
    #gnome-firmware #frontend for fwupd
    #firmware-manager
    davinci-resolve #https://nixos.wiki/wiki/DaVinci_Resolve
  ];

  programs.evince.enable = true;

  system.stateVersion = "${vars.system.stateVersion}";
}
