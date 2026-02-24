{ ... }: {
  # Basic editor options
  opts = {
    # Line numbers and UI
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;
    colorcolumn = "120";

    # Indentation and formatting
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;
    smartindent = true;

    # Search
    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;

    # Editor behavior
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    mouse = "a";
    clipboard = "unnamedplus";

    # File handling
    backup = false;
    writebackup = false;
    swapfile = false;
    undofile = true;

    # Performance
    updatetime = 1000;
    timeoutlen = 300;
  };

  # Global variables
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  # LSP UI, diagnostics, and other config is now in lua/config/init.lua
  # Theme colors and UI setup is now in lua/theme/ and lua/config/ui.lua
}
