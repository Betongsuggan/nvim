{
  config.plugins = {
    # Git signs for showing git diff in sign column
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "│";
          };
          change = {
            text = "│";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
          untracked = {
            text = "┆";
          };
        };
        
        signcolumn = true; # Toggle with `:Gitsigns toggle_signs`
        numhl = false; # Toggle with `:Gitsigns toggle_numhl`
        linehl = false; # Toggle with `:Gitsigns toggle_linehl`
        word_diff = false; # Toggle with `:Gitsigns toggle_word_diff`
        
        watch_gitdir = {
          follow_files = true;
        };
        
        attach_to_untracked = true;
        current_line_blame = false; # Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol"; # 'eol' | 'overlay' | 'right_align'
          delay = 1000;
          ignore_whitespace = false;
          virt_text_priority = 100;
        };
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>";
        
        sign_priority = 6;
        update_debounce = 100;
        status_formatter = null; # Use default
        max_file_length = 40000; # Disable if file is longer than this (in lines)
        
        preview_config = {
          # Options passed to nvim_open_win
          border = "rounded";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        };
        
        # Gitsigns on_attach is handled via keymaps.nix
        on_attach = ''
          function(bufnr)
            -- All keymaps are defined in keymaps.nix for centralization
            -- This function is kept for any future buffer-local configurations
          end
        '';
      };
    };
    
    # LazyGit integration
    lazygit = {
      enable = true;
    };
    
    # Git conflict resolution
    git-conflict = {
      enable = true;
      settings = {
        default_mappings = true; # disable buffer local mapping created by this plugin
        default_commands = true; # disable commands created by this plugin
        disable_diagnostics = false; # This will disable the diagnostics in a buffer whilst it is conflicted
        list_opener = "copen"; # command or function to open the conflicts list
        highlights = {
          incoming = "DiffAdd";
          current = "DiffText";
        };
      };
    };
    
    # Show git blame in floating window
    gitblame = {
      enable = true;
      settings = {
        enabled = false; # Enable by default, toggle with :GitBlameToggle
        message_template = "  <summary> • <date> • <author>";
        date_format = "%r";
        virtual_text_column = null; # Show blame info at end of line
        display_virtual_text = true;
        ignored_filetypes = [
          "help"
          "fugitive"
          "alpha"
          "neo-tree"
          "Trouble"
          "trouble"
          "lazy"
          "mason"
          "notify"
          "toggleterm"
        ];
        delay = 1000;
        highlight_group = "Comment";
        use_blame_commit_file_urls = false;
      };
    };
  };
  
  config.extraConfigLua = ''
    -- Git commands and utilities
    
    -- Custom git commands
    vim.api.nvim_create_user_command('GitBlameToggle', function()
      vim.cmd('GitBlameToggle')
    end, {})
    
    vim.api.nvim_create_user_command('GitLog', function()
      vim.cmd('!git log --oneline --graph --decorate --all')
    end, {})
    
    vim.api.nvim_create_user_command('GitStatus', function()
      vim.cmd('!git status')
    end, {})
  '';
}
