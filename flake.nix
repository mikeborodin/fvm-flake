{
  description = "Flutter Version Manager - Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs { inherit system; };
      dart = pkgs.dart;
    in
    rec {
      packages = {
        default = pkgs.stdenv.mkDerivation {
          pname = "fvm";
          version = "3.2.1";
          src = pkgs.fetchFromGitHub {
            owner = "leoafarias";
            repo = "fvm";
            rev = "7bb641e4d7e9107a56b71102b47957d4aafc3650";
            sha256 = "i7sJRBrS5qyW8uGlx+zg+wDxsxgmolTMcikHyOzv3Bs=";
          };

          buildInputs = [ dart ];

          buildPhase = ''
            export PUB_CACHE=$TMPDIR/.pub-cache
            dart pub get
            export PATH="$PATH:/usr/bin"
            dart compile exe bin/main.dart -o fvm 
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp fvm $out/bin/
          '';

          meta = with pkgs.lib; {
            description = "FVM CLI application";
            license = licenses.mit;
          };
        };
      };
    }
  );
}
