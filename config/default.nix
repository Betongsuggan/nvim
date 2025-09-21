{
  imports = [
    ./keymaps.nix
    ./lsp.nix
    ./theme.nix
    ./plugins
  ];

  # Basic Neovim configuration
  config = {
    # General settings
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Tabs and indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;

      # Search settings
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;

      # Appearance
      termguicolors = true;
      background = "dark";
      signcolumn = "yes";
      wrap = false;
      cursorline = true;
      scrolloff = 8;
      sidescrolloff = 8;

      # Behavior
      hidden = true;
      errorbells = false;
      swapfile = false;
      backup = false;
      undofile = true;
      clipboard = "unnamedplus";
      splitright = true;
      splitbelow = true;
      autochdir = false;
      iskeyword = "@,48-57,_,192-255,-";
      mouse = "a";

      # Performance
      updatetime = 50;
      timeoutlen = 500;
      redrawtime = 1500;
      ttimeoutlen = 5;

      # Completion
      completeopt = [ "menuone" "noselect" "noinsert" ];
      shortmess = "c";

      # Folding
      foldmethod = "expr";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    # Global variables
    globals = {
      mapleader = " ";
      maplocalleader = "\\";

      # Disable some built-in plugins we don't need
      loaded_gzip = 1;
      loaded_zip = 1;
      loaded_zipPlugin = 1;
      loaded_tar = 1;
      loaded_tarPlugin = 1;
      loaded_getscript = 1;
      loaded_getscriptPlugin = 1;
      loaded_vimball = 1;
      loaded_vimballPlugin = 1;
      loaded_2html_plugin = 1;
      loaded_logiPat = 1;
      loaded_rrhelper = 1;
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
      loaded_netrwSettings = 1;
      loaded_netrwFileHandlers = 1;
    };

    # Highlight on yank
    highlight = {
      YankHighlight = {
        bg = "#3e4451";
        fg = "none";
      };
    };

    autoCmd = [
      {
        event = [ "TextYankPost" ];
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank({
                higroup = "YankHighlight",
                timeout = 200,
              })
            end
          '';
        };
      }
    ];
  };
}
