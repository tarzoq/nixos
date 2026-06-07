{ config, lib, vars, ... }:
{
  ######### Boilerplate ###########
  #modules.niri.imports = "include \"file.hm.kdl\"";
  #################################

  options.modules.niri = {
    imports = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Custom niri imports";
    };
  };
  config = let
    cfg = config.modules.niri;
    hasImports = cfg.imports != null;
  in {
    home-manager.users."${vars.user.name}" = {
      home.file."nixos/config/niri/niri-imports.hm.kdl".text = ''
        ${cfg.imports}
      '';
    };
  };
}
