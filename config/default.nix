{ ... }: {
  # Nixvim is automatically enabled when using makeNixvimWithModule
  viAlias = true;
  vimAlias = true;
  
  # Colorscheme
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      transparent_background = false;
    };
  };

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

  # Plugins configuration
  plugins = {
    # File finder and navigation
    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          prompt_prefix = " ";
          selection_caret = " ";
          path_display = ["truncate"];
          sorting_strategy = "ascending";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
        };
      };
    };

    # Syntax highlighting
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
        };
        indent = {
          enable = true;
        };
        ensure_installed = [
          "go"
          "gomod"
          "gosum"
          "lua"
          "nix"
          "bash"
          "json"
          "yaml"
          "markdown"
        ];
      };
    };

    # LSP Configuration
    lsp = {
      enable = true;
      servers = {
        gopls = {
          enable = true;
          settings = {
            gopls = {
              analyses = {
                unusedparams = true;
                unreachable = true;
              };
              staticcheck = true;
              gofumpt = true;
            };
          };
        };
      };
    };

    # Autocompletion
    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
          "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
      };
    };

    # Snippet engine (required for cmp)
    luasnip = {
      enable = true;
    };

    # LSP UI improvements
    lspkind = {
      enable = true;
    };

    # Icons (required by telescope and other plugins)
    web-devicons = {
      enable = true;
    };
  };

  # Keymaps
  keymaps = [
    # General editor keymaps
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = { desc = "Clear search highlights"; };
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options = { desc = "Save file"; };
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<CR>";
      options = { desc = "Quit"; };
    }

    # Buffer navigation
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bd<CR>";
      options = { desc = "Delete buffer"; };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<CR>";
      options = { desc = "Next buffer"; };
    }

    # Telescope file finding
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options = { desc = "Find files"; };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options = { desc = "Find in files (grep)"; };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options = { desc = "Find buffers"; };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options = { desc = "Find help"; };
    }

    # LSP keymaps
    {
      mode = "n";
      key = "gd";
      action = "vim.lsp.buf.definition";
      options = { desc = "Go to definition"; };
    }
    {
      mode = "n";
      key = "gD";
      action = "vim.lsp.buf.declaration";
      options = { desc = "Go to declaration"; };
    }
    {
      mode = "n";
      key = "gi";
      action = "vim.lsp.buf.implementation";
      options = { desc = "Go to implementation"; };
    }
    {
      mode = "n";
      key = "gr";
      action = "vim.lsp.buf.references";
      options = { desc = "Show references"; };
    }
    {
      mode = "n";
      key = "K";
      action = "vim.lsp.buf.hover";
      options = { desc = "Show hover documentation"; };
    }
    {
      mode = "n";
      key = "<leader>rn";
      action = "vim.lsp.buf.rename";
      options = { desc = "Rename symbol"; };
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = "vim.lsp.buf.code_action";
      options = { desc = "Code actions"; };
    }
    {
      mode = "n";
      key = "<leader>f";
      action = "vim.lsp.buf.format";
      options = { desc = "Format code"; };
    }

    # Diagnostic keymaps
    {
      mode = "n";
      key = "[d";
      action = "vim.diagnostic.goto_prev";
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = "vim.diagnostic.goto_next";
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "vim.diagnostic.open_float";
      options = { desc = "Show diagnostic"; };
    }

    # Go-specific keymaps
    {
      mode = "n";
      key = "<leader>gt";
      action = "<cmd>!go test ./...<CR>";
      options = { desc = "Run Go tests"; };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>!go build<CR>";
      options = { desc = "Build Go project"; };
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>!go run .<CR>";
      options = { desc = "Run Go project"; };
    }
  ];
}