# Treesitter: highlighting, indentation and folding
{ config, ... }:
{
  plugins.treesitter = {
    enable = true;
    # Grammars come from Nix (nvim-treesitter doesn't install any itself), so
    # this list is what's available; the default is every grammar in nixpkgs.
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      # Languages worked in
      go
      gomod
      gosum
      typescript
      tsx
      javascript
      lua
      nix
      bash
      json
      yaml
      rust
      toml
      ron
      kotlin
      # Markdown, incl. the inline grammar render-markdown needs
      markdown
      markdown_inline
      # Neovim's own files and injections (help, :checkhealth, queries)
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
