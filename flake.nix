{
  description = "Betongsuggans Neovim configuration";

  inputs = {
    # Stable, so consumers on the same NixOS release can make this follow
    # their nixpkgs (nixvim's branch matches the release)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      treefmt-nix,
      claudecode-nvim,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          # git-conflict.nvim is marked unfree in nixpkgs (license metadata
          # quirk, not a real restriction). Allow it specifically rather
          # than opening the gate to all unfree packages.
          config.allowUnfreePredicate =
            pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "git-conflict.nvim" ];
        };

      treefmtFor =
        pkgs:
        treefmt-nix.lib.evalModule pkgs {
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

      nvimFor =
        system:
        nixvim.legacyPackages.${system}.makeNixvimWithModule {
          pkgs = pkgsFor system;
          module = ./config;
          extraSpecialArgs = {
            inherit claudecode-nvim;
          };
        };
    in
    {
      packages = forAllSystems (system: rec {
        default = nvim;
        nvim = nvimFor system;
      });

      formatter = forAllSystems (
        system: (treefmtFor (pkgsFor system)).config.build.wrapper
      );

      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          nvim = self.packages.${system}.default;
        in
        {
          formatting = (treefmtFor pkgs).config.build.check self;
          # The build itself plus an end-to-end startup: --headless "+q"
          # executes the entire generated init.lua, catching Lua errors that
          # evaluation can't.
          inherit nvim;
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
        }
      );

      # Working on this flake; language tooling comes from each project's
      # own devShell
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              self.packages.${system}.default
              (treefmtFor pkgs).config.build.wrapper
              pkgs.nixd
              pkgs.statix
              pkgs.deadnix
              pkgs.stylua
            ];
          };
        }
      );
    };
}
