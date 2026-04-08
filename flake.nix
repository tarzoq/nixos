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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    #system = "x86_64-linux";
    #pkgs = import nixpkgs {
    #  inherit system;
    #  config = {
    #    allowUnfree = true;
    #  };
    #};
    vars = import /etc/nixos/variables.nix; #just a symlink, still edited directly from repo (which is gitignored as to not have it be public)
  in {
    nixosConfigurations.${vars.system.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs vars; };
      modules = [
        ./hosts/${vars.system.hostname}

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${vars.user.name} = import ./home.nix;
            backupFileExtension = "backup";
	    overwriteBackup = true;
	    extraSpecialArgs = { inherit vars; };
          };
        }
      ];
    };
  };
}
