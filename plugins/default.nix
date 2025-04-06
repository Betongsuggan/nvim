{ pkgs }:
{
  vimPlugins = with pkgs.vimPlugins; [
    # Navigation
    ctrlp
    bufferline-nvim
    vim-smoothie
    telescope-nvim
    nvim-scrollbar

    # Editor plugins
    nvim-autopairs
    lualine-nvim
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

    # AI stuff
    avante-nvim

    # LSP
    nvim-lspconfig

    # null-ls
    none-ls-nvim

    # Show code actions icon
    nvim-lightbulb

    # Show code actions in popup
    actions-preview-nvim

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
    go-nvim

    # Haskell plugins
    haskell-tools-nvim

    # Nix plugins
    vim-nix

    # Rust plugins
    rust-tools-nvim

    # Themes
    gruvbox-nvim

    # Lua
    neodev-nvim

    # Git integration
    gitsigns-nvim
    diffview-nvim
    telescope-github-nvim

    # Utils
    FixCursorHold-nvim
    plenary-nvim
    render-markdown-nvim
  ];

  runtimeDependencies = with pkgs; [
    tree-sitter
    ripgrep
    curl
    git
    gitAndTools.delta # Better diff viewer
    gitAndTools.gh # GitHub CLI

    # Bash
    nodePackages.bash-language-server

    # Go
    gopls
    gofumpt
    gotools
    golines
    golangci-lint
    golangci-lint-langserver
    nilaway

    # Haskell
    haskell-language-server
    haskellPackages.hoogle

    # Java
    java-language-server

    # JSON/YAML
    vscode-langservers-extracted

    # Kotlin
    kotlin-language-server

    # Lua
    lua-language-server
    stylua
    luajitPackages.luacheck

    # Nix
    nil
    nixfmt-classic
    statix
    nixpkgs-fmt

    # Rust
    rust-analyzer
    rustfmt

    # Terraform
    terraform-ls

    # Typescript
    typescript-language-server
    prettierd
  ];
}
