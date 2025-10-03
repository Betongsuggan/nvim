{
  description = "Betongsuggans Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
    claudecode-nvim = {
      url = "github:coder/claudecode.nvim/2e6ea6f2a63cdf4fd3c05e6a054151d46848d319";
      flake = false;
    };
  };

  outputs = { nixpkgs, nixvim, flake-utils, claudecode-nvim, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nixvim' = nixvim.legacyPackages.${system};

        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = ./config;
          extraSpecialArgs = {
            inherit claudecode-nvim;
          };
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
            pkgs.golines
            # TypeScript/JavaScript development tools
            pkgs.nodejs_20
            pkgs.typescript
            pkgs.nodePackages.typescript-language-server
            pkgs.nodePackages.vscode-langservers-extracted # For eslint
          ];
        };
      });
}
