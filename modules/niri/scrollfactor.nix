{ config, vars, ... }:
{
  modules.niri.imports = "include \"scrollfactor.hm.kdl\"";
  home-manager.users."${vars.user.name}" = {
    home.file."nixos/config/niri/scrollfactor.hm.kdl".text = ''
      /////////// lower scroll factor /////////////// workaround for brave/chromium browsers on wayland reading raw libinput instead of scroll stack
      window-rule {
        match app-id=r#"(?i)electron|brave|discord|vscode|spotify|teams-for-linux"# //case-insensitive
      
        scroll-factor 0.15
      } 
    '';
  };
}
