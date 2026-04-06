{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    vars = import ./variables.nix;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
	inherit vars;
      };
      modules = [
        ./configuration.nix
	./noctalia.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users."${vars.user.name}" = import ./home.nix;
            backupFileExtension = "backup";
	    overwriteBackup = true;
	    extraSpecialArgs = {
	      inherit vars;
	    };
          };
        }
        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        #nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
      ];
    };
  };
}
