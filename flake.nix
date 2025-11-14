{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Dependencias de DMS
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

    # Home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri (compositor)
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs, home-manager, dankMaterialShell, niri, ...
  }:
  {
    nixosConfigurations.nixos_pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./config/configuration.nix

        # Home-manager como módulo
        home-manager.nixosModules.home-manager

        # Config del usuario
        {
          home-manager.users.joronix = {
            imports = [
              dankMaterialShell.homeModules.dankMaterialShell.default
              dankMaterialShell.homeModules.dankMaterialShell.niri
              niri.homeModules.niri
            ];

            # ---- DankMaterialShell ----
            programs.dankMaterialShell = {
              enable = true;

              niri = {
                enableKeybinds = true;
                enableSpawn = true;
              };
            };

            # ---- Niri compositor ----
            programs.niri.enable = true;
          };
        }
      ];
    };
  };
}
