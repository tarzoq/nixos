{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; #set to nixos-${vars.system.stateVersion} if not unstable

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; #same thing for this one

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dolphin-overlay.url = "github:rumboon/dolphin-overlay/c32758737a0cb02d0bf380753d11df1b8537a944";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs: 
  let
    vars = import /etc/nixos/variables.nix; #just a symlink, still edited directly from ./ (which is gitignored as to not have it commited to public repo)
  in {
    nixosConfigurations.${vars.system.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs vars; };
      modules = [
        ./hosts/${vars.system.hostname}.nix
        home-manager.nixosModules.home-manager
	stylix.nixosModules.stylix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${vars.user.name} = import ./home.nix;
            backupFileExtension = "backup";
            overwriteBackup = true;
            extraSpecialArgs = { inherit vars;};
          };
        }
      ];
    };
  };
}
