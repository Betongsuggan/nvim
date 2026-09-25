# Every plugin module; each is a regular nixvim module and the module system
# merges them. Keymaps for all of them are in keymaps.nix.
{ ... }:
{
  imports = [
    ./plugins/coding/lsp.nix
    ./plugins/coding/completion.nix
    ./plugins/coding/treesitter.nix

    ./plugins/editor/editing.nix
    ./plugins/editor/extras.nix

    ./plugins/ui/statusline.nix
    ./plugins/ui/which-key.nix
    ./plugins/ui/icons.nix
    ./plugins/ui/snacks.nix

    ./plugins/git/gitsigns.nix
    ./plugins/git/diffview.nix

    ./plugins/testing/neotest.nix
    ./plugins/debugging/dap.nix

    ./plugins/tools/claudecode.nix
  ];

  # Lazy loading: plugins with lazyLoad.settings load on their trigger, and a
  # require() of a not-yet-loaded plugin (e.g. from a keymap) loads it
  plugins.lz-n.enable = true;
  plugins.lzn-auto-require.enable = true;
}
