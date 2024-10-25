{ pkgs }:
with pkgs.vimPlugins; [
  # Navigation
  ctrlp
  bufferline-nvim
  vim-smoothie
  telescope-nvim
  nvim-scrollbar

  # Editor plugins
  nvim-autopairs
  feline-nvim
  nvim-notify
  vim-illuminate

  # File tree
  nvim-tree-lua
  nvim-web-devicons

  # Syntax highlighting
  nvim-treesitter.withAllGrammars
  nvim-treesitter-textobjects

  # Keybindings
  legendary-nvim

  # Indentation
  #indent-blankline-nvim

  # Collaboration
  #(plugin "jbyuki/instant.nvim")

  # AI stuff
  ChatGPT-nvim
  pkgs.avante

  # LSP
  nvim-lspconfig

  # null-ls
  none-ls-nvim

  ## Show references in a popup
  #(plugin "wiliamks/nice-reference.nvim")
  ## Show code actions icon
  nvim-lightbulb
  ## Show code actions in popup
  #(plugin "aznhe21/actions-preview.nvim")

  # LSP Testing
  nvim-dap
  nvim-dap-go
  neotest
  neotest-go
  neotest-plenary
  vimspector

  ## Show LSP Processes
  fidget-nvim

  # Completions
  nvim-cmp
  cmp-nvim-lsp
  cmp-buffer
  cmp-path
  cmp-cmdline
  cmp-nvim-lua
  cmp-vsnip
  cmp-nvim-lsp-signature-help
  lspkind-nvim

  # Snippets
  luasnip
  cmp_luasnip

  # Go plugins
  #(plugin "ray-x/go.nvim")
  #(plugin "ray-x/guihua.lua")

  # Haskell plugins
  haskell-tools-nvim

  # Nix plugins
  vim-nix

  # Rust plugins
  rust-tools-nvim

  # Themes
  #gruvbox
  #(plugin "ellisonleao/gruvbox.nvim")

  # Typescript
  vim-prettier

  # Lua
  neodev-nvim

  # Utils
  FixCursorHold-nvim
  plenary-nvim
  #(plugin "MeanderingProgrammer/render-markdown.nvim")
]
