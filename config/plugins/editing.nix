{ ... }: {
  plugins = {
    # Auto-pairing for brackets, quotes, etc.
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        disable_filetype = [ "TelescopePrompt" ];
        map_cr = true;
        map_bs = true;
        enable_check_bracket_line = false;
      };
    };

    # Surround functionality (add/change/delete surrounding chars)
    nvim-surround = {
      enable = true;
      settings = {
        keymaps = {
          insert = "<C-g>s";
          insert_line = "<C-g>S";
          normal = "ys";
          normal_cur = "yss";
          normal_line = "yS";
          normal_cur_line = "ySS";
          visual = "S";
          visual_line = "gS";
          delete = "ds";
          change = "cs";
          change_line = "cS";
        };
      };
    };

    # Comment toggling
    comment = {
      enable = true;
      settings = {
        padding = true;
        sticky = true;
        # Comment operations using <leader>/ prefix to avoid conflicts with code actions
        toggler = {
          line = "<leader>//";
          block = "<leader>/?";
        };
        opleader = {
          line = "<leader>/";
          block = "<leader>?";
        };
        extra = {
          above = "<leader>/O";
          below = "<leader>/b";
          eol = "<leader>/A";
        };
      };
    };

    # Formatting with conform.nvim
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          go = [ "golines" "gofumpt" ];
        };
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        formatters = {
          stylua = {
            prepend_args = [ "--indent-type" "Spaces" "--indent-width" "2" ];
          };
          nixfmt = { prepend_args = [ "--width" "80" ]; };
          golines = {
            prepend_args = [ "--max-len=120" "--base-formatter=gofumpt" ];
          };
        };
      };
    };
  };

  # Auto commands for formatting and cleanup
  autoCmd = [{
    event = [ "BufWritePre" ];
    pattern = [ "*" ];
    callback = {
      __raw = ''
        function()
          -- Save cursor position
          local save = vim.fn.winsaveview()
          -- Remove trailing whitespace
          vim.cmd([[%s/\s\+$//e]])
          -- Restore cursor position
          vim.fn.winrestview(save)
        end
      '';
    };
  }];

  # Key mappings for manual formatting
  keymaps = [{
    mode = "n";
    key = "<leader>cf";
    action = {
      __raw = ''
        function()
          require("conform").format({ lsp_fallback = true })
        end
      '';
    };
    options = {
      desc = "Format current buffer";
      silent = true;
    };
  }];
}
