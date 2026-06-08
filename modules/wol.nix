{ config, pkgs, lib, ... }:
{
  ######### Boilerplate ###########
  #modules.wol.card = "enp12s0"; #ip a
  #################################

  options.modules.wol = {
    card = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Network card to enable WoL on";
    };
  };
  config = let
    cfg = config.modules.wol;
    hasCard = cfg.card != null;
  in {
    #https://wiki.nixos.org/wiki/Wake_on_LAN
    networking.interfaces."${cfg.card}".wakeOnLan.enable = true;
    networking.firewall.allowedUDPPorts = [ 9 ];
  };
}
