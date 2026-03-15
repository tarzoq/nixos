{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
      #extraSpecialArgs = let
      #  hostname = nixos;
      #   stateVersion = "25.11";
    };
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit system; };
      modules = [
        ./configuration.nix
        #home-manager.nixosModules.home-manager
        #{
        #  home-manager = {
        #    useGlobalPkgs = true;
        #    useUserPackages = true;
        #    users.user = import ./home.nix;
        #    backupFileExtension = "backup";
        #  };
        #}
          # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      #nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
      ];
    };
  };
}
