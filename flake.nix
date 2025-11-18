{
  description = "NixOS configuration with DankMaterialShell";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
       url = "github:noctalia-dev/noctalia-shell";
       inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri-flake, fenix, ... }@inputs:{
    nixosConfigurations.pc_niri = nixpkgs.lib.nixosSystem {  # ← Cambia "tu-hostname" por el nombre de tu PC
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [

        {
          nixpkgs.overlays = [ niri-flake.overlays.niri
            fenix.overlays.default];
        }
        ./config/configuration.nix
        ./config/hardware-configuration.nix
        {nixpkgs.config.allowUnfree = true;}
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
