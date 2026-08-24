{ pkgs, ... }:
let
  theme = import ./theme.nix;
in
{
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  # Core nixvim configuration
  viAlias = true;
  vimAlias = true;

  # Colorscheme from theme
  colorschemes.${theme.name} = theme.colorscheme;

  # Include modular Lua files
  extraFiles = {
    "lua/config/init.lua" = {
      text = builtins.readFile ../lua/config/init.lua;
    };
    "lua/config/keymaps.lua" = {
      text = builtins.readFile ../lua/config/keymaps.lua;
    };
    "lua/config/floating_diff.lua" = {
      text = builtins.readFile ../lua/config/floating_diff.lua;
    };
  };

  # Additional packages needed by plugins
  extraPackages = with pkgs; [
    ripgrep # Required by Snacks.picker.grep
    unzip # Required by the kotlin-lsp jar:// reader (lua/config/init.lua)
    # Go tooling
    go # Required by neotest-golang test runs
    # Debugging tools
    delve # Go debugger
    nodejs_22 # Node.js runtime for TypeScript/JavaScript debugging
    lldb # LLVM debugger for Rust and C/C++
    # Formatters
    stylua # Lua formatter
    nixfmt # Nix formatter
    golines # Go line-length formatter (conform)
    gofumpt # Go formatter, golines base formatter (conform)
    # Rust tooling
    rust-analyzer # Rust language server
    rustfmt # Rust formatter
    clippy # Rust linter
    cargo # Rust package manager
    rustc # Rust compiler

    # Kotlin tooling (kotlin-lsp itself comes via plugins.lsp.servers.kotlin_lsp.package)
    ktfmt # Kotlin formatter (Google)

    gcc
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    # Popular colorschemes
    gruvbox-nvim
    tokyonight-nvim
    nord-nvim
    onedark-nvim
    nightfox-nvim
    dracula-nvim
    kanagawa-nvim
    rose-pine

  ];

  # Initialize all Lua modules
  extraConfigLua = ''
    -- Core config (LSP handlers, diagnostics, folds, file-change autocmds).
    require('config').setup()
  '';
}
