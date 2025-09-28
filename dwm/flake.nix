{
  description = "dwm window manager (dwm fork) flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    packages.x86_64-linux.dwm = pkgs.stdenv.mkDerivation rec {
      pname = "dwm";
      version = "6.6";

      src = ./.;

      nativeBuildInputs = [pkgs.pkg-config];
      buildInputs = [
        pkgs.xorg.libX11
        pkgs.xorg.libXft
        pkgs.xorg.libXinerama
        pkgs.fontconfig
        pkgs.freetype
      ];

      shellHook = ''
        export PKG_CONFIG_PATH="${pkgs.xorg.libX11}/lib/pkgconfig:${pkgs.xorg.libXft}/lib/pkgconfig:${pkgs.xorg.libXinerama}/lib/pkgconfig:${pkgs.fontconfig}/lib/pkgconfig:${pkgs.freetype}/lib/pkgconfig"
      '';

      buildPhase = ''
        make clean
        make CC="cc $(pkg-config --cflags --libs x11 xft xinerama freetype2 fontconfig)"
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp dwm $out/bin/
      '';

      meta = with pkgs.lib; {
        description = "dwm window manager (dwm fork) with full X11/Xft/Fontconfig support";
        license = licenses.bsd3;
      };
    };
  };
}
