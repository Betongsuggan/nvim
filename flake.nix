{
  description = "Betongsuggans Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, nixvim, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
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
            # TypeScript/JavaScript development tools
            pkgs.nodejs_20
            pkgs.typescript
            pkgs.nodePackages.typescript-language-server
            pkgs.nodePackages.vscode-langservers-extracted # For eslint
          ];
        };
      });
}
