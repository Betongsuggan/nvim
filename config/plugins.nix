# Aggregates all plugin modules. Each file is a regular nixvim module;
# the module system merges plugins/keymaps/autoCmd/extraConfigLua/etc.
{ ... }:
{
  imports = [
    ./plugins/coding/lsp.nix
    ./plugins/coding/completion.nix
    ./plugins/coding/treesitter.nix
    ./plugins/coding/rust.nix

    ./plugins/editor/editing.nix
    ./plugins/editor/navigation.nix
    ./plugins/editor/extras.nix

    ./plugins/ui/statusline.nix
    ./plugins/ui/which-key.nix
    ./plugins/ui/icons.nix
    ./plugins/ui/snacks.nix

    ./plugins/git/gitsigns.nix
    ./plugins/git/diffview.nix
    ./plugins/git/floating-diff.nix
    ./plugins/git/git-conflict.nix

    ./plugins/diagnostics/trouble.nix

    ./plugins/testing/neotest.nix

    ./plugins/tools/markdown.nix
    ./plugins/tools/claudecode.nix
  ];
}
