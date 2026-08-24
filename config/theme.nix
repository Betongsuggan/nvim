# Default colorscheme (build-time). Runtime theme switching is themery
# (config/plugins/editor/extras.nix); the other colorschemes it offers are
# raw plugins in config/default.nix.
let
  # Colorscheme plugin configurations (NixVim settings)
  colorschemes = {
    catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
      };
    };
  };

  # Default theme selection
  # Available themes (runtime switchable via themery): catppuccin, gruvbox,
  # tokyonight, nord, onedark, nightfox, dracula, kanagawa, rose-pine
  defaultTheme = "catppuccin";
in
{
  # Theme name (used by colorschemes.${name} in default.nix)
  name = defaultTheme;

  # NixVim colorscheme configuration
  colorscheme = colorschemes.${defaultTheme};
}
