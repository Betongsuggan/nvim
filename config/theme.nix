# Colors: a colorscheme plugin (theme.colorscheme: catppuccin mocha, gruvbox
# dark, kanagawa wave), or a bare base16 palette (theme.base16) through
# mini.base16 for themes without one. The plugins style the plugins used here
# (snacks, blink, which-key, gitsigns, neotest, dap, diffview, mini.icons).
{ config, lib, ... }:
let
  inherit (config.theme) colorscheme;
  palette = config.theme.base16;
  use = name: palette == null && colorscheme == name;
in
{
  colorschemes.mini-base16 = lib.mkIf (palette != null) {
    enable = true;
    settings = { inherit palette; };
  };

  colorschemes.catppuccin = lib.mkIf (use "catppuccin") {
    enable = true;
    settings = {
      flavour = "mocha";
      # On top of its defaults (blink, dap, flash, gitsigns, mini,
      # render-markdown). Listed rather than auto-detected: detection runs
      # git (vim.pack) at every startup.
      integrations = {
        blink_pairs = true;
        diffview = true;
        grug_far = true;
        navic.enabled = true;
        neotest = true;
        snacks.enabled = true;
        which_key = true;
      };
    };
  };

  colorschemes.gruvbox = lib.mkIf (use "gruvbox") {
    enable = true;
    settings.contrast = "";
  };

  colorschemes.kanagawa = lib.mkIf (use "kanagawa") {
    enable = true;
    settings.theme = "wave";
  };
}
