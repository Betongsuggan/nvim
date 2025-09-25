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
        toggler = {
          line = "<leader>c/";
          block = "<leader>c?";
        };
        opleader = {
          line = "<leader>c/";
          block = "<leader>c?";
        };
        extra = {
          above = "<leader>cO";
          below = "<leader>cb";
          eol = "<leader>cA";
        };
      };
    };
  };
}
