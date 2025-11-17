{ config, lib, pkgs, inputs, ... }:  # ← Agregar inputs aquí
{
  imports = [
    ./hardware-configuration.nix
  ];

  # nixpkgs.overlays = [
  #   (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
  # ];
    nixpkgs.overlays = [
    inputs.fenix.overlays.default
  ];

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
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configuración de Niri
  programs.niri = {
    enable = true;
    # Sobrescribir el paquete para deshabilitar tests
    package = inputs.niri.packages.${pkgs.system}.niri-stable.overrideAttrs (oldAttrs: {
      doCheck = false;  # ← Deshabilitar tests que fallan
    });
  };

  # Habilitar Wayland y sesión de login
  services.xserver.enable = true;  # Necesario para display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Variables de entorno para NVIDIA + Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Para apps Electron/Chromium en Wayland
    WLR_NO_HARDWARE_CURSORS = "1";  #Fix para cursores en NVIDIA
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXPKGS_ALLOW_UNFREE=1;
  };

  networking.hostName = "nixos";

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
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
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

    # Herramientas útiles para Wayland/Niri
    wayland-utils
    xwayland  # Para apps X11 en Wayland
    alacritty
    fuzzel
    mako
    waybar
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.11";  # ← Versión correcta
}
