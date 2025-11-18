# desktop/niri_custom.nix
{ config, pkgs, inputs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    settings = {
      environment  ={
        DISPLAY = ":0";
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
      };

      outputs ={
        "DP-3"={
          focus-at-startup = true;
          mode = {
            width = 2560;
            height = 1080;
            refresh = 99.949;
            };
        };
        "HDMI-A-1"={
          transform.rotation=270;
          mode = {
          width = 1920;
          height = 1080;
          };
        };
      };
      # Lanzar Noctalia al inicio:
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
        { command = [ "xwayland-satellite" ":0"]; }
      ];

      # Configuración básica
      prefer-no-csd = true;

      # Input
      input = {
        keyboard.xkb = {
          layout = "us,es";
          options = "grp:alt_shift_toggle";
        };


        mouse = {
          accel-speed = 0.0;
        };
      };

      # Layout
      # layout = {
      #   gaps = 8;
      #   center-focused-column = "on-overflow";
      #   preset-column-widths = [
      #     { proportion = 0.33333; }
      #     { proportion = 0.5; }
      #     { proportion = 0.66667; }
      #   ];
      # };

      # Keybindings
      binds = with config.lib.niri.actions; {
        #Multimedia
        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-";
        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ;
        "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ;

        "XF86AudioPlay".action = spawn-sh "playerctl play-pause";
        "XF86AudioNext".action = spawn-sh "playerctl next";
        "XF86AudioPrev".action = spawn-sh "playerctl previous";
        "XF86AudioStop".action = spawn-sh "playerctl stop";

        # Aplicaciones

        "Mod+T".action = spawn "alacritty";
        "Mod+D".action = spawn "fuzzel";

        #Mostrar hotkeys
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # Ventanas
        "Mod+Q".action = close-window;
        "Mod+F".action = fullscreen-window;
        "Mod+M".action = maximize-column;

        # Navegación
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;

        # Mover ventanas
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;

        # Workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;

        # # Mover a workspace
        # "Mod+Shift+1".action = move-column-to-workspace 1;
        # "Mod+Shift+2".action = move-column-to-workspace 2;
        # "Mod+Shift+3".action = move-column-to-workspace 3;
        # "Mod+Shift+4".action = move-column-to-workspace 4;

        # Sistema
        "Mod+Shift+E".action = quit;
        "Mod+Shift+R".action = spawn "sh" "-c" "niri msg action quit; niri";
      };

      # Ventanas flotantes
      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 12.0;
            bottom-right = 12.0;
            top-left = 12.0;
            top-right = 12.0;
          };
          clip-to-geometry = true;
        }
      ];
    };
  };
}
