{ config, lib, pkgs, inputs, ... }:  # ← Agregar inputs aquí
{
  imports = [
    ./hardware-configuration.nix
  ];

  # nixpkgs.overlays = [
  #   (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
  # ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NVIDIA drivers para Wayland
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = true;  # ← CRÍTICO para Wayland
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  boot.kernelParams = [
     "nvidia-drm.modeset=1"
     "nvidia-drm.fbdev=1"
   ];
   environment.etc."nvidia/nvidia-application-profiles-rc.d/niri-vram-fix.conf".text = ''
     {
       "profiles": [
         {
           "name": "niri",
           "settings": [
             {
               "key": "__GL_HEAP_ALLOC_POLICY",
               "value": 1
             }
           ]
         }
       ],
       "rules": [
         {
           "pattern": {
             "feature": "procname",
             "matches": "niri"
           },
           "profile": "niri"
         }
       ]
     }
   '';
  # Configuración de Niri
  programs.niri = {
    enable = true;
    # Sobrescribir el paquete para deshabilitar tests
    # package = inputs.niri.packages.${pkgs.system}.niri-stable.overrideAttrs (oldAttrs: {
      # doCheck = false;  # ← Deshabilitar tests que fallan
    # });
  };

  # Habilitar Wayland y sesión de login
  services.xserver.enable = true;  # Necesario para display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  xdg = {
      portal = {
        enable = true;

        # Portales correctos para Niri
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome  # ← Principal para Niri
          xdg-desktop-portal-gtk    # ← Fallback
        ];

        # Configuración para Niri
        config = {
          niri = {  # ← Cambiar de  "niri"
            default = [ "gnome" "gtk" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          };

          # Configuración común como fallback
          common = {
            default = [ "gnome" "gtk" ];
          };
        };
      };
    };

    # Servicios necesarios
    services.dbus.enable = true;



  # Variables de entorno para NVIDIA + Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Para apps Electron/Chromium en Wayland
    WLR_NO_HARDWARE_CURSORS = "1";  #Fix para cursores en NVIDIA
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXPKGS_ALLOW_UNFREE=1;
  };
  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  networking.hostName = "nixos";
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";  # o el tema que instales
    XCURSOR_SIZE = "24";
  };

  time.timeZone = "America/Costa_Rica";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.flatpak.enable = true;

  users.users.joronix = {
    password = "fungy2005";  #  CAMBIAR ESTO - no pongas passwords en plain text
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      tree
      nushell
      neovim
      zellij
    ];
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
  };

  programs.firefox.enable = true;
  programs.xwayland.enable = true;

  # Terminal para Wayland en lugar de gnome-terminal
  # Kitty ya está en environment.systemPackages y funciona con Wayland

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # (fenix.complete.withComponents [
      # "cargo"
      # "clippy"
      # "rust-src"
      # "rustc"
      # "rustfmt"
    # ])
    rust-analyzer-nightly
    gcc
    vim
    wget
    git
    curl
    kitty  # ← Terminal compatible con Wayland
    xclip
    wl-clipboard  # ← Clipboard para Wayland
    nodejs
    unzip
    lldb
    nixos-shell
    direnv
    cron
    discord-ptb
    warp-terminal
    pomodoro
    brave
    google-chrome
    vivaldi
    python3
    vscode
    postgresql_17_jit
    jetbrains-toolbox
    zed-editor
    playerctl

    # Herramientas útiles para Wayland/Niri
    wayland-utils
    xwayland-satellite  # Para apps X11 en Wayland
    alacritty
    fuzzel
    mako
    bibata-cursors
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.11";  # ← Versión correcta
}
