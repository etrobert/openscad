{
  description = "OpenSCAD dev shell with gridfinity-rebuilt library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gridfinity-rebuilt = {
      url = "github:kennetek/gridfinity-rebuilt-openscad";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, gridfinity-rebuilt, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      devShells = forEachSystem (pkgs: {
        default =
          let
            gridfinityLib = pkgs.stdenvNoCC.mkDerivation {
              name = "gridfinity-rebuilt-openscad";
              src = gridfinity-rebuilt;
              installPhase = ''
                mkdir -p $out/gridfinity-rebuilt-openscad
                cp -r . $out/gridfinity-rebuilt-openscad/
              '';
            };
          in
          pkgs.mkShell {
            packages = with pkgs; [
              openscad
            ];

            shellHook = ''
              export OPENSCADPATH=${gridfinityLib}
            '';
          };
      });

      formatter = forEachSystem (pkgs: pkgs.nixfmt);
    };
}
