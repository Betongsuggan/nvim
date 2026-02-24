# Theme configuration - Nix build-time settings only
# Runtime colors and theme switching are handled by lua/theme/
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
    gruvbox = {
      enable = true;
      settings = {
        contrast = "medium";
        transparent_mode = false;
      };
    };
  };

  # Default theme selection
  # Available themes (runtime switchable): catppuccin, gruvbox, tokyonight,
  # nord, onedark, nightfox, dracula, kanagawa, rose-pine
  defaultTheme = "catppuccin";

in {
  # Theme name (used by lualine and passed to Lua setup)
  name = defaultTheme;

  # NixVim colorscheme configuration
  colorscheme = colorschemes.${defaultTheme};
}
