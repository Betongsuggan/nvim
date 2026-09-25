# Colors: a base16 palette when one is given (theme.base16, e.g. the
# desktop's stylix scheme), otherwise catppuccin mocha. mini.base16 covers the
# highlight groups of the plugins used here (snacks, blink, which-key,
# gitsigns, neotest, dap, mini.icons); catppuccin lists them below.
{ config, lib, ... }:
let
  palette = config.theme.base16;
in
{
  colorschemes.mini-base16 = lib.mkIf (palette != null) {
    enable = true;
    settings = { inherit palette; };
  };

  colorschemes.catppuccin = lib.mkIf (palette == null) {
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
}
