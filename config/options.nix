# The flake's own options: what a consumer chooses with
#   inputs.nvim.packages.${system}.default.extend { languages.go.enable = true; }
{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;
  language = name: {
    enable = mkEnableOption "${name} support (language server, formatter, tests, debugging)";
  };
in
{
  options = {
    # Nix, Lua, Markdown and the data formats are always supported; the
    # others add a language with its toolchain integration (languages.nix)
    languages = {
      nix = {
        server = mkOption {
          type = types.enum [
            "nixd"
            "nil"
          ];
          default = "nixd";
          description = ''
            nixd evaluates Nix (nixpkgs and option completion, ~700 MiB with
            LLVM); nil only analyses the file (~80 MiB).
          '';
        };
        nixd.options = mkOption {
          type = types.attrsOf types.str;
          default = { };
          example = {
            nixos = ''(builtins.getFlake "/home/me/nix-home").nixosConfigurations.laptop.options'';
          };
          description = "Nix expressions of option sets nixd completes and documents, by name";
        };
      };
      # Lua is always formatted and highlighted; this adds its language server
      lua = language "the Lua language server";
      go = language "Go";
      rust = language "Rust";
      typescript = language "TypeScript/JavaScript";
      kotlin = language "Kotlin";
    };

    theme.base16 = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      default = null;
      example = {
        base00 = "#1e1e2e";
        base0D = "#89b4fa";
      };
      description = ''
        A base16 palette (base00 … base0F, "#rrggbb") to color the editor with,
        e.g. the desktop's stylix colors. null uses catppuccin mocha.
      '';
    };
  };
}
