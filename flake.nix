{
  description = "Betongsuggan's Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    stable-nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    plugin-render-markdown = {
      url = "github:MeanderingProgrammer/render-markdown.nvim";
      flake = false;
    };
    plugin-go = {
      url = "github:ray-x/go.nvim";
      flake = false;
    };
    plugin-guihua = {
      url = "github:ray-x/guihua.lua";
      flake = false;
    };
    plugin-actions-preview = {
      url = "github:aznhe21/actions-preview.nvim";
      flake = false;
    };
    plugin-nice-reference = {
      url = "github:wiliamks/nice-reference.nvim";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, stable-nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlayFlakeInputs = prev: final: {
          vimPlugins = final.vimPlugins // {
            render-markdown = prev.vimUtils.buildVimPlugin {
              name = "render-markdown";
              src = inputs.plugin-render-markdown;
            };
            go-nvim = prev.vimUtils.buildVimPlugin {
              name = "go-nvim";
              src = inputs.plugin-go;
            };
            guihua = prev.vimUtils.buildVimPlugin {
              name = "guihua";
              src = inputs.plugin-guihua;
            };
            actions-preview = prev.vimUtils.buildVimPlugin {
              name = "actions-preview";
              src = inputs.plugin-actions-preview;
            };
            nice-reference = prev.vimUtils.buildVimPlugin {
              name = "nice-reference";
              src = inputs.plugin-nice-reference;
            };
          };
        };

        overlayNeovim = prev: final:
          let
            pkgs = import nixpkgs {
              inherit system;
            };
          in
          {
            myNeovim = import ./packages {
              inherit pkgs;
            };
          };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlayFlakeInputs overlayNeovim ];
        };
      in
      {
        packages.default = pkgs.myNeovim;
        apps.default = {
          type = "app";
          program = "${pkgs.myNeovim}/bin/nvim";
        };
      }
    );
}
