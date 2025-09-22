{
  description = "My Neovim configuration with nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { nixpkgs, nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.legacyPackages.${system};
          nixvim' = nixvimLib.makeNixvimWithModule {
            inherit pkgs;
            module = import ./config;
          };
        in
        {
          packages = {
            default = nixvim';
            nvim = nixvim';
          };

          # For development - test your config
          devShells.default = pkgs.mkShell {
            buildInputs = [ nixvim' ];
          };
        };
    };
}
