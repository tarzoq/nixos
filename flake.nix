{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; #main
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/22a3adbe7c5c8c8a10a635d32c9ef7fc01a6e4b8";

    #stylix = {
    #  url = "github:nix-community/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }@inputs: 
  let
    vars = import /etc/nixos/variables.nix; #just a symlink, still edited directly from ./ (which is gitignored as to not have it commited to public repo)
  in {
    nixosConfigurations.${vars.system.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs vars; };
      modules = [
        ./hosts/${vars.system.hostname}.nix
        home-manager.nixosModules.home-manager
	#stylix.nixosModules.stylix
	nix-flatpak.nixosModules.nix-flatpak
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${vars.user.name} = import ./home.nix;
            backupFileExtension = "backup";
            overwriteBackup = true;
            extraSpecialArgs = { inherit vars;};
          };
	  nixpkgs.overlays = [
	    (final: prev: {
	      stable = import inputs.nixpkgs-stable {
	        system = final.stdenv.hostPlatform.system;
	        config.allowUnfree = true;
	      };
	    })
	  ];
        }
      ];
    };
  };
}
