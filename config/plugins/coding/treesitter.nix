# Treesitter: highlighting, indentation and folding
{ config, ... }:
{
  plugins.treesitter = {
    enable = true;
    # Grammars come from Nix (nvim-treesitter doesn't install any itself), so
    # this list is what's available; the default is every grammar in nixpkgs.
    # Grammars come from Nix (nvim-treesitter installs none itself); each
    # language adds its own (languages.nix), these are the editor's own
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      # Neovim's files and injections (help, :checkhealth, queries)
      vim
      vimdoc
      query
      regex
      # Git buffers (commit messages, rebase todo, diffs)
      gitcommit
      git_rebase
      diff
    ];
    highlight.enable = true;
    indent.enable = true;
    folding.enable = true;
  };
}
