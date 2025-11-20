{ pkgs, stdenv, fetchurl, appimageTools }:

let
  pname = "pear-desktop";
  version = "3.11.0"; # Verifica la última versión
  icon = ./ytm-icon.png;
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pear-devs/pear-desktop/releases/download/v3.11.0/YouTube-Music-3.11.0.AppImage";
    sha256 = "cfc0a0d5be6245e2c65bfe543747399b6bf7c02a49ce27e16ab99d143b68056d"; # Necesitas calcular el hash
  };

  extraInstallCommands = ''
    # Crea los directorios necesarios
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps

    # Instala el icono desde el mismo directorio
    install -Dm644 ${icon} $out/share/icons/hicolor/256x256/apps/${pname}.png

    # Crea el archivo .desktop
    cat > $out/share/applications/${pname}.desktop <<EOF
[Desktop Entry]
Name=Pear Desktop
Comment=YouTube Music Desktop Player
Exec=$out/bin/${pname} %U
Icon=${pname}
Terminal=false
Type=Application
Categories=AudioVideo;Audio;Player;Music;
MimeType=x-scheme-handler/peardesktop;
StartupWMClass=pear-desktop
StartupNotify=true
EOF
  '';

}
