{
  description = "Minimal nixvim configuration for Go development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      nixvim' = nixvim.legacyPackages.${system};

      nvim = nixvim'.makeNixvimWithModule {
        inherit pkgs;
        module = ./config;
      };
    in {
      packages = {
        default = nvim;
        nvim = nvim;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          nvim
          # Go development tools
          pkgs.go
          pkgs.gopls
          pkgs.delve
        ];
      };
    });
}
