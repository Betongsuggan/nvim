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
    # Nix, Lua, Markdown and the data formats are always supported; these add
    # a language with its whole toolchain integration (see languages.nix)
    languages = {
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
