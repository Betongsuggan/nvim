{
  config.plugins.trouble = {
    enable = true;
    settings = {
      position = "bottom";
      height = 10;
      width = 50;
      icons = true;
      mode = "workspace_diagnostics";
      severity = null; # nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
      fold_open = "";
      fold_closed = "";
      group = true; # group results by file
      padding = true; # add an extra new line on top of the list
      cycle_results = true; # cycle item list when reaching beginning or end of list
      action_keys = {
        close = "q";
        cancel = "<esc>";
        refresh = "r";
        jump = [ "<cr>" "<tab>" "<2-leftmouse>" ];
        open_split = [ "<c-x>" ];
        open_vsplit = [ "<c-v>" ];
        open_tab = [ "<c-t>" ];
        jump_close = [ "o" ];
        toggle_mode = "m";
        switch_severity = "s";
        toggle_preview = "P";
        hover = "K";
        preview = "p";
        open_code_href = "c";
        close_folds = [ "zM" "zm" ];
        open_folds = [ "zR" "zr" ];
        toggle_fold = [ "zA" "za" ];
        previous = "k";
        next = "j";
        help = "?";
      };
      multiline = true;
      indent_lines = true;
      win_config = {
        border = "rounded";
      };
      auto_open = false;
      auto_close = false;
      auto_preview = true;
      auto_fold = false;
      auto_jump = [ "lsp_definitions" ];
      include_declaration = [
        "lsp_references"
        "lsp_implementations"
        "lsp_definitions"
      ];
      signs = {
        error = "";
        warning = "";
        hint = "";
        information = "";
        other = "";
      };
      use_diagnostic_signs = false;
    };
  };

  config.extraConfigLua = ''
    -- All keymaps are centralized in keymaps.nix
    -- This file only contains trouble configuration and utility functions
    
    -- Custom trouble commands (commands are allowed, keymaps are not)
    vim.api.nvim_create_user_command('TroubleWorkspace', function()
      require('trouble').toggle('workspace_diagnostics')
    end, {})
    
    vim.api.nvim_create_user_command('TroubleDocument', function()
      require('trouble').toggle('document_diagnostics')
    end, {})
    
    vim.api.nvim_create_user_command('TroubleQuickfix', function()
      require('trouble').toggle('quickfix')
    end, {})
    
    vim.api.nvim_create_user_command('TroubleLoclist', function()
      require('trouble').toggle('loclist')
    end, {})
    
    vim.api.nvim_create_user_command('TroubleReferences', function()
      require('trouble').toggle('lsp_references')
    end, {})
    
    vim.api.nvim_create_user_command('TroubleDefinitions', function()
      require('trouble').toggle('lsp_definitions')
    end, {})
    
    vim.api.nvim_create_user_command('TroubleTypeDefinitions', function()
      require('trouble').toggle('lsp_type_definitions')
    end, {})
    
    -- Auto-refresh trouble on quickfix changes
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        require('trouble').refresh()
        if not require('trouble').is_open() then
          require('trouble').open("quickfix")
        end
      end,
    })
    
    -- Highlight git conflict markers
    vim.api.nvim_create_autocmd('BufRead', {
      callback = function()
        vim.fn.matchadd('Error', '^<<<<<<<.*')
        vim.fn.matchadd('Error', '^=======.*')
        vim.fn.matchadd('Error', '^>>>>>>>.*')
      end,
    })
  '';
}
