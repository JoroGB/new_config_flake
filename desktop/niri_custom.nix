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
          position = {
            x = 0;
            y=-400;
          };
          transform.rotation=270;
          mode = {
          width = 1920;
          height = 1080;
          };
        };
      };

      layout = {
        background-color = "transparent";
        gaps = 6;
       focus-ring = {
         width = 1.5;
        } ;
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
        focus-follows-mouse.enable = true;
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
        "Ctrl+Shift+T".action = spawn-sh "warp-terminal";
        "Ctrl+Shift+Tab".action = spawn-sh "kitty";
        "Mod+T".action = spawn "alacritty";
        "Mod+D".action = spawn "fuzzel";
        "Mod+Tab".action = open-overview;

        #Mostrar hotkeys
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # Ventanas
        "Mod+Q".action = close-window;
        # "Mod+F".action = fullscreen-window;
        # "Mod+M".action = maximize-column;
        "Mod+BracketLeft".action  = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Ctrl+B".action  =  expel-window-from-column;


        # Navegación

       "Mod+Left".action = focus-column-left;
       "Mod+Down".action = focus-window-down;
       "Mod+Up".action   = focus-window-up;
       "Mod+Right".action= focus-column-right;
       "Mod+H".action    = focus-column-left;
       "Mod+J".action    = focus-window-down;
       "Mod+K".action    = focus-window-up;
       "Mod+L".action    = focus-column-right;

       "Mod+Shift+Left".action = move-column-left;
       "Mod+Shift+Down".action = move-window-down;
       "Mod+Shift+Up".action   = move-window-up;
       "Mod+Shift+Right".action= move-column-right;
       "Mod+Shift+H".action    = move-column-left;
       "Mod+Shift+J".action    = move-window-down;
       "Mod+Shift+K".action    = move-window-up;
       "Mod+Shift+L".action    = move-column-right;


        # Mover ventanas
        "Mod+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Ctrl+L".action = move-column-to-monitor-right;
        # "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
        # "Mod+Shift+K".action = move-window-up-or-to-workspace-up;

        # Workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;

        # "Mod+Shift+1".action = move-column-to-workspace 1;
        # "Mod+Shift+2".action = move-column-to-workspace 2;
        # "Mod+Shift+3".action = move-column-to-workspace 3;
        # "Mod+Shift+4".action = move-column-to-workspace 4;
        #Monitores
        "Mod+Alt+H".action = focus-monitor-left;
        "Mod+Alt+L".action = focus-monitor-right;

       "Mod+Shift+Ctrl+Left".action  = move-column-to-monitor-left;
       "Mod+Shift+Ctrl+Down".action  = move-column-to-monitor-down;
       "Mod+Shift+Ctrl+Up".action    = move-column-to-monitor-up;
       "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
       "Mod+Shift+Ctrl+H".action     = move-column-to-monitor-left;
       "Mod+Shift+Ctrl+J".action     = move-column-to-monitor-down;
       "Mod+Shift+Ctrl+K".action     = move-column-to-monitor-up;
       "Mod+Shift+Ctrl+L".action     = move-column-to-monitor-right;


         # Mover a workspace
        "Mod+Page_Down".action     = focus-workspace-down;
        "Mod+Page_Up".action       = focus-workspace-up;
        "Mod+U".action             = focus-workspace-down;
        "Mod+I".action             = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action= move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action  = move-column-to-workspace-up;
        "Mod+Ctrl+U".action        = move-column-to-workspace-down;
        "Mod+Ctrl+I".action        = move-column-to-workspace-up;

        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action   = move-workspace-up;
        "Mod+Shift+U".action         = move-workspace-down;
        "Mod+Shift+I".action         = move-workspace-up;

        # expel
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+R".action = switch-preset-column-width;

        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action  = reset-window-height;
        "Mod+F".action       = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;

        #Expand focused column
        "Mod+Ctrl+F".action =  expand-column-to-available-width;

        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

      #Move the focused window between the floating and the tiling layout.
      "Mod+V".action       = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

      # Toggle tabbed column display mode.
      # Windows in this column will appear as vertical tabs,
      # rather than stacked on top of each other.
      "Mod+W".action = toggle-column-tabbed-display;


       # ERROR
       # "Print".action = screenshot;
       # "Ctrl+Print".action = screenshot-screen;
       # "Alt+Print".action = screenshot-window;


      "Ctrl+Alt+Delete".action =   quit;

       # Powers off the monitors. To turn them back on, do any input like
       # moving the mouse or pressing any other key.
      "Mod+Shift+P".action  = power-off-monitors;

      # Sistema
      "Mod+Shift+E".action = quit;
        # "Mod+Shift+R".action = spawn "sh" "-c" "niri msg action quit; niri";

        #  Finer height adjustments when in column with other windows.
      };
      layer-rules = [
        {
          matches = [
            {
              namespace = "^noctalia-wallpaper*";
            }
          ];
          place-within-backdrop = true;
        }
      ];
      overview = {
        workspace-shadow.enable = false;
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

      debug = {
      honor-xdg-activation-with-invalid-serial = {};
    };

      # debug.honor-xdg-activation-with-invalid-serial = true;
    };
  };
}
