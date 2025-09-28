{
  description = "RWM (dwm fork) window manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    packages.x86_64-linux.rwm = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation rec {
      pname = "rwm";
      version = "6.6";

      src = ./.;

      nativeBuildInputs = [nixpkgs.legacyPackages.x86_64-linux.pkg-config];
      buildInputs = [
        nixpkgs.legacyPackages.x86_64-linux.xorg.libX11
        nixpkgs.legacyPackages.x86_64-linux.xorg.libXft
        nixpkgs.legacyPackages.x86_64-linux.xorg.libXinerama
        nixpkgs.legacyPackages.x86_64-linux.fontconfig
        nixpkgs.legacyPackages.x86_64-linux.freetype
      ];

      buildPhase = ''
        make clean
        make CC="cc $(pkg-config --cflags --libs x11 xft xinerama freetype2 fontconfig)"
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp dwm $out/bin/
      '';

      meta = with nixpkgs.lib; {
        description = "RWM window manager (dwm fork)";
        license = licenses.bsd3;
      };
    };

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = [
        nixpkgs.legacyPackages.x86_64-linux.pkg-config
        nixpkgs.legacyPackages.x86_64-linux.xorg.libX11
        nixpkgs.legacyPackages.x86_64-linux.xorg.libXft
        nixpkgs.legacyPackages.x86_64-linux.xorg.libXinerama
        nixpkgs.legacyPackages.x86_64-linux.fontconfig
        nixpkgs.legacyPackages.x86_64-linux.freetype
      ];
    };
  };
}
