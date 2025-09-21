{
  config.plugins.toggleterm = {
    enable = true;
    settings = {
      size = 20;
      open_mapping = "[[<c-\\>]]";
      hide_numbers = true;
      shade_filetypes = [ ];
      shade_terminals = true;
      shading_factor = 2;
      start_in_insert = true;
      insert_mappings = true;
      terminal_mappings = true;
      persist_size = true;
      persist_mode = true;
      direction = "float";
      close_on_exit = true;
      shell = "bash"; # Change this to your preferred shell
      auto_scroll = true;

      float_opts = {
        border = "curved";
        winblend = 0;
        highlights = {
          border = "Normal";
          background = "Normal";
        };
      };

      winbar = {
        enabled = false;
        name_formatter = ''
          function(term)
            return term.name
          end
        '';
      };
    };
  };

  config.extraConfigLua = ''
      -- Terminal functions are available via keymaps.nix
      -- This keeps the terminal configurations clean and centralized
    
      -- Set terminal keymaps when terminal is opened  
      function _G.set_terminal_keymaps()
        -- Terminal navigation is handled in keymaps.nix
        -- This function is kept for any additional terminal-specific configs
      end
    
      -- Apply terminal keymaps when terminal is opened
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    .keymap.set('n', '<leader>gb', function() go_build() end, vim.tbl_extend('force', opts, { desc = 'Go build' }))
    end,
    })
  '';
}
