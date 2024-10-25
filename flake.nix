{
  description = "Betongsuggan's Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    plugin-instant = {
      url = "github:jbyuki/instant.nvim";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, neovim, flake-utils, ... }@inputs: 
  flake-utils.lib.eachDefaultSystem (system:
    let
      overlayFlakeInputs = prev: final: {
        inherit (neovim.packages.${system}) neovim;

        vimPlugins = final.vimPlugins // {
          instant = import ./packages/vimPlugins/instant.nix {
            src = plugin-instant;
            pkgs = prev;
          };
        };
      };

      overlayThisNeovim = prev: final: {
        myNeovim = import ./packages {
          pkgs = final;
        };
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlayFlakeInputs overlayThisNeovim ];
      };

      packageSet = builtins.getAttr system pkgs.packages;
    in {
      packages.default = pkgs.myNeovim;
      apps.default = {
        type = "app";
        program = "${pkgs.myNeovim}/bin/nvim";
      };
    }
  );
}
