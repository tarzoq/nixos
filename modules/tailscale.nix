{ config, pkgs, vars, ... }:

#https://wiki.nixos.org/wiki/Tailscale
{
  # 1. Enable the service and the firewall
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraSetFlags = [ "--operator=${vars.user.name}" ];
  };
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];

  # 3. Optimization: Prevent systemd from waiting for network online 
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;
#environment.systemPackages.pkgs.tail-tray;
  #environment.systemPackages.pkgs.tailscale-systray; #official client - https://www.reddit.com/r/Tailscale/comments/1mqe4ei/hey_desktop_linux_users_help_us_test_a_new/
}
