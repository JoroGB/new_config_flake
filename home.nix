{ config, pkgs, inputs, ... }:

{
  home.username = "joronix";
  home.homeDirectory = "/home/joronix";
  home.stateVersion = "24.11";

  imports = [
  ];

  homeConfigurations.joronix = home-manager.lib.homeManagerConfigurations {
    pkgs=nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      {
        nixpkgs.overlays = [ niri-flake.overlays.niri ];
      }
      niri-flake.homeModules.niri
      ./home.nix
    ]

  }

}
