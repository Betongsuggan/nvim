{
  description = "Betongsuggans Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claudecode-nvim = {
      url = "github:coder/claudecode.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      flake-utils,
      treefmt-nix,
      claudecode-nvim,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # git-conflict.nvim is marked unfree in nixpkgs (license metadata
          # quirk, not a real restriction). Allow it specifically rather
          # than opening the gate to all unfree packages.
          config.allowUnfreePredicate =
            pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "git-conflict.nvim" ];
        };
        nixvim' = nixvim.legacyPackages.${system};

        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          # Match conform-nvim's on-save formatters (config/plugins/editor/editing.nix)
          # so `nix fmt` and format-on-save agree.
          programs.nixfmt = {
            enable = true;
            width = 80;
          };
          programs.stylua.enable = true;
          programs.deadnix.enable = true;
        };

        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = ./config;
          extraSpecialArgs = {
            inherit claudecode-nvim;
          };
        };
      in
      {
        packages = {
          default = nvim;
          nvim = nvim;
        };

        formatter = treefmtEval.config.build.wrapper;

        checks = {
          formatting = treefmtEval.config.build.check self;
          # The build itself plus an end-to-end startup: --headless "+q"
          # executes the entire generated init.lua, catching Lua errors that
          # evaluation can't.
          nvim = nvim;
          smoke =
            pkgs.runCommand "nvim-smoke"
              {
                nativeBuildInputs = [ nvim ];
              }
              ''
                export HOME=$TMPDIR
                nvim --headless "+q"
                touch $out
              '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            nvim
            # Working on this flake
            treefmtEval.config.build.wrapper
            pkgs.nixd
            pkgs.statix
            pkgs.deadnix
            pkgs.stylua
            # Go development tools
            pkgs.go
            pkgs.gopls
            pkgs.delve
            pkgs.golines
            # TypeScript/JavaScript development tools
            pkgs.nodejs_22
            pkgs.typescript
            pkgs.vtsls
            pkgs.vscode-langservers-extracted # For eslint
          ];
        };
      }
    );
}
