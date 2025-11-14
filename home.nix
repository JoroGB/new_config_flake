{ config, pkgs, ... }:

{
  home.username = "joronix";
  home.homeDirectory = "/home/joronix";

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    discord-ptb
    warp-terminal
    pomodoro

    brave
    google-chrome
    vivaldi
  ];
}
