{
  description = "Example Darwin system flake";

  inputs = {
#    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
#    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
#      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{ self
    , nix-darwin
    , home-manager
    , mac-app-util
    , nixpkgs
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#reis-work
      darwinConfigurations."reis-work" = nix-darwin.lib.darwinSystem {
       
       specialArgs = inputs;

	modules = [
          ./hosts/macwork/configuration.nix

          mac-app-util.darwinModules.default

          home-manager.darwinModules.home-manager
          {
	    # Backs up any files it will override
	    # Rather than exit with error
            home-manager.backupFileExtension = "backup";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
	    home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
            home-manager.users."reis.holmes".imports = [
              ./hosts/macwork/home.nix
            ];
          }
        ];
      };

    };
}

