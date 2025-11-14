{
  description = "NixOS configuration with DankMaterialShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-cli = {
      url = "github:AvengeMedia/danklinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
      inputs.dms-cli.follows = "dms-cli";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, dankMaterialShell, ... }@inputs: {
    nixosConfigurations.pc_dank = nixpkgs.lib.nixosSystem {  # ← Cambia "tu-hostname" por el nombre de tu PC
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./config/configuration.nix
        ./config/hardware-configuration.nix

        # Integración de Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };  # ← Esto pasa inputs a home.nix
          home-manager.users.joronix = import ./home.nix;
        }
      ];
    };
  };
}
