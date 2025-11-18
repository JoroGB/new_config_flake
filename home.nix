{ config, pkgs, inputs, ... }:
{
  imports =[
    inputs.niri-flake.homeModules.niri
    ./desktop/niri_custom.nix

    inputs.noctalia.homeModules.default
    ./desktop/noctalia.nix


    ./programs/fenix.nix
  ];


    # wayland.windowManager.sway = {
    #   enable = true;
    #   systemdIntegration = true;
    # };
  home.username = "joronix";
  home.homeDirectory = "/home/joronix";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    slurp
  ];


}
