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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      treefmt-nix,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      inherit (nixpkgs) lib;
      pkgsFor = system: nixpkgs.legacyPackages.${system};

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
        };
    in
    {
      # The configuration as a nixvim module, to import into another
      # nixvim configuration (programs.nixvim.imports, makeNixvimWithModule)
      nixvimModules.default = ./config;

      # Core (Nix, Lua, Markdown, data formats). Other languages:
      #   packages.<system>.default.extend { languages.go.enable = true; }
      packages = forAllSystems (system: rec {
        default = nvim;
        nvim = nvimFor system;
        # Every language, e.g. to try things out with `nix run .#full`
        full = nvim.extend {
          languages =
            lib.genAttrs
              [
                "go"
                "rust"
                "typescript"
                "kotlin"
                "lua"
              ]
              (_: {
                enable = true;
              });
        };
      });

      formatter = forAllSystems (
        system: (treefmtFor (pkgsFor system)).config.build.wrapper
      );

      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          # Starts the editor on a file of each kind; any error during
          # startup (init.lua, plugin setup, a filetype's autocmds) fails it
          smoke =
            name: nvim:
            pkgs.runCommand "nvim-smoke-${name}"
              {
                # git: gitsigns and diffview expect it on PATH, as it is
                # wherever code is edited
                nativeBuildInputs = [
                  nvim
                  pkgs.git
                ];
              }
              ''
                  export HOME=$TMPDIR
                  cd $TMPDIR
                  echo 'x = 1' > a.lua
                  echo '# t' > a.md
                  echo '{ }' > a.nix
                  echo 'fn main() {}' > a.rs
                  echo 'package main' > a.go
                  echo 'const x = 1;' > a.ts
                  # Errors that aren't silenced are printed; silenced ones (e.g.
                # the runtime's own `silent! unmap` in ftplugins) are not
                nvim --headless a.lua a.md a.nix a.rs a.go a.ts \
                  +'bufdo doautocmd FileType' +qa > log 2>&1
                cat log
                ! grep -E 'Error|E[0-9]+:' log
                touch $out
              '';
        in
        {
          formatting = (treefmtFor pkgs).config.build.check self;
          smoke = smoke "core" self.packages.${system}.default;
          smoke-full = smoke "full" self.packages.${system}.full;
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
