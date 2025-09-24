{ ... }: {
  # Basic editor options
  opts = {
    # Line numbers and UI
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;
    
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
    updatetime = 300;
    timeoutlen = 500;
  };
  
  # Global variables
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
}