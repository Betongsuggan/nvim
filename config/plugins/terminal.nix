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
    local Terminal = require('toggleterm.terminal').Terminal
    
    -- Create specialized terminals
    
    -- Lazygit terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "rounded",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })
    
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end
    
    -- Node REPL terminal
    local node = Terminal:new({
      cmd = "node",
      direction = "float",
      float_opts = {
        border = "rounded",
      },
    })
    
    function _NODE_TOGGLE()
      node:toggle()
    end
    
    -- Python REPL terminal
    local python = Terminal:new({
      cmd = "python3",
      direction = "float",
      float_opts = {
        border = "rounded",
      },
    })
    
    function _PYTHON_TOGGLE()
      python:toggle()
    end
    
    -- Go run terminal for current project
    local function go_run()
      local go_run_term = Terminal:new({
        cmd = "go run .",
        direction = "horizontal",
        close_on_exit = false,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })
      go_run_term:toggle()
    end
    
    -- Go test terminal for current package
    local function go_test()
      local go_test_term = Terminal:new({
        cmd = "go test -v ./...",
        direction = "horizontal", 
        close_on_exit = false,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })
      go_test_term:toggle()
    end
    
    -- Go build terminal
    local function go_build()
      local go_build_term = Terminal:new({
        cmd = "go build",
        direction = "horizontal",
        close_on_exit = false,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })
      go_build_term:toggle()
    end
    
    -- Keymaps for specialized terminals
    local opts = { noremap = true, silent = true }
    
    -- Lazygit
    vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", vim.tbl_extend("force", opts, { desc = "LazyGit" }))
    
    -- REPL terminals
    vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", vim.tbl_extend("force", opts, { desc = "Node REPL" }))
    vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", vim.tbl_extend("force", opts, { desc = "Python REPL" }))
    
    -- Go development terminals
    vim.keymap.set("n", "<leader>gr", function() go_run() end, vim.tbl_extend("force", opts, { desc = "Go run" }))
    vim.keymap.set("n", "<leader>gt", function() go_test() end, vim.tbl_extend("force", opts, { desc = "Go test" }))
    vim.keymap.set("n", "<leader>gb", function() go_build() end, vim.tbl_extend("force", opts, { desc = "Go build" }))
    
    -- Terminal window navigation
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end
    
    -- Apply terminal keymaps when terminal is opened
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    
    -- Custom commands for Go development
    vim.api.nvim_create_user_command('GoRun', function()
      go_run()
    end, {})
    
    vim.api.nvim_create_user_command('GoTest', function()
      go_test()
    end, {})
    
    vim.api.nvim_create_user_command('GoBuild', function()
      go_build()
    end, {})
    
    -- Quick terminal for running commands
    vim.api.nvim_create_user_command('Term', function(opts)
      local cmd = opts.args ~= "" and opts.args or vim.o.shell
      local term = Terminal:new({
        cmd = cmd,
        direction = "float",
        float_opts = {
          border = "rounded",
        },
        close_on_exit = false,
      })
      term:toggle()
    end, { nargs = '?' })
    
    -- File-type specific terminal commands
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'go',
      callback = function()
        local opts = { buffer = true, silent = true }
        vim.keymap.set('n', '<leader>gr', function() go_run() end, vim.tbl_extend('force', opts, { desc = 'Go run' }))
        vim.keymap.set('n', '<leader>gt', function() go_test() end, vim.tbl_extend('force', opts, { desc = 'Go test' }))
        vim.keymap.set('n', '<leader>gb', function() go_build() end, vim.tbl_extend('force', opts, { desc = 'Go build' }))
      end,
    })
  '';
}
