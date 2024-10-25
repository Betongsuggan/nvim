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
  };
  outputs = { self, nixpkgs, neovim, flake-utils }: 
  flake-utils.lib.eachDefaultSystem (system:
    let
      overlayFlakeInputs = prev: final: {
        inherit (neovim.packages.${system}) neovim;
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
