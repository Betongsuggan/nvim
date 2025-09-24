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

  # LSP UI configuration for rounded borders
  extraConfigLua = ''
    -- Configure LSP floating windows with rounded borders
    local border_opts = {
      border = "rounded",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }

    -- LSP handlers with rounded borders
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
      focusable = true,
      style = "minimal",
      source = "always",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      focusable = false,
      style = "minimal",
    })

    -- Diagnostic configuration with rounded borders
    vim.diagnostic.config({
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
        style = "minimal",
      },
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Additional LSP window configuration
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
  '';
}