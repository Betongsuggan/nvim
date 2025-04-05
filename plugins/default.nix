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
    ChatGPT-nvim
    avante-nvim
  
    # LSP
    nvim-lspconfig
  
    # null-ls
    none-ls-nvim
  
    ## Show references in a popup
    #nice-reference

    ## Show code actions icon
    nvim-lightbulb
    ## Show code actions in popup
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
    #guihua
  
    # Haskell plugins
    haskell-tools-nvim
  
    # Nix plugins
    vim-nix
  
    # Rust plugins
    rust-tools-nvim
  
    # Themes
    gruvbox-nvim
  
    # Typescript
    vim-prettier
  
    # Lua
    neodev-nvim
  
    # Utils
    FixCursorHold-nvim
    plenary-nvim
    render-markdown-nvim
  ];

  runtimeDependencies = with pkgs; [
    tree-sitter
    ripgrep
    curl

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

    # Json
    nodePackages.vscode-json-languageserver

    # Kotlin
    kotlin-language-server

    # Lua
    lua-language-server

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
    nodePackages.typescript
    nodePackages.prettier
    nodePackages.typescript-language-server
  ];
}

