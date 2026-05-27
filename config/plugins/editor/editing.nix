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
      # v4 removed the `keymaps` setup option; defaults (ys/cs/ds/S/...) are auto-mapped.
      # To customize, use vim.keymap.set with the <Plug>(nvim-surround.*) mappings.
    };

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          go = [ "golines" "gofumpt" ];
          kotlin = [ "ktfmt" ];
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
