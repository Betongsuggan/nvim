# Text editing plugins (autopairs, surround, formatting)
# Note: Native Neovim 0.10+ commenting (gc/gcc) is used instead of comment.nvim
{ ... }: {
  plugins = {
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
          timeout_ms = 2000;
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

  autoCmd = [{
    event = [ "BufWritePre" ];
    pattern = [ "*" ];
    callback = {
      __raw = ''
        function()
          local save = vim.fn.winsaveview()
          vim.cmd([[%s/\s\+$//e]])
          vim.fn.winrestview(save)
        end
      '';
    };
  }];
}
