{
  config.keymaps = [
    # Basic navigation and editing
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = { desc = "Clear search highlights"; };
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = { desc = "Move to left window"; };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = { desc = "Move to bottom window"; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = { desc = "Move to top window"; };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = { desc = "Move to right window"; };
    }

    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<CR>";
      options = { desc = "Increase window height"; };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<CR>";
      options = { desc = "Decrease window height"; };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<CR>";
      options = { desc = "Decrease window width"; };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<CR>";
      options = { desc = "Increase window width"; };
    }

    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>bprevious<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "<leader>l";
      action = "<cmd>bnext<CR>";
      options = { desc = "Next buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<CR>";
      options = { desc = "Delete buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>bdelete!<CR>";
      options = { desc = "Force delete buffer"; };
    }

    {
      mode = "v";
      key = "<";
      action = "<gv";
      options = { desc = "Indent left"; };
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options = { desc = "Indent right"; };
    }

    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options = { desc = "Move selection down"; };
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options = { desc = "Move selection up"; };
    }

    # File Explorer (Neo-tree)
    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>Neotree reveal<CR>";
      options = { desc = "Focus file explorer"; };
    }

    # Telescope
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
      options = { desc = "Live grep"; };
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
      options = { desc = "Help tags"; };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<CR>";
      options = { desc = "Recent files"; };
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = "<cmd>Telescope colorscheme<CR>";
      options = { desc = "Colorschemes"; };
    }
    {
      mode = "n";
      key = "<leader>fm";
      action = "<cmd>Telescope marks<CR>";
      options = { desc = "Marks"; };
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>Telescope grep_string<CR>";
      options = { desc = "Find word under cursor"; };
    }

    # LSP
    {
      mode = "n";
      key = "gD";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_declaration = false
            for _, client in pairs(clients) do
              if client.server_capabilities.declarationProvider then
                supports_declaration = true
                break
              end
            end
            
            if supports_declaration then
              vim.lsp.buf.declaration()
            else
              vim.lsp.buf.definition() -- Fallback to definition
            end
          end
        '';
      };
      options = { desc = "Go to declaration (or definition)"; };
    }
    {
      mode = "n";
      key = "gd";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_definition = false
            for _, client in pairs(clients) do
              if client.server_capabilities.definitionProvider then
                supports_definition = true
                break
              end
            end
            
            if supports_definition then
              vim.lsp.buf.definition()
            else
              print("Definition not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Go to definition"; };
    }
    {
      mode = "n";
      key = "gi";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_implementation = false
            for _, client in pairs(clients) do
              if client.server_capabilities.implementationProvider then
                supports_implementation = true
                break
              end
            end
            
            if supports_implementation then
              vim.lsp.buf.implementation()
            else
              print("Implementation not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Go to implementation"; };
    }
    {
      mode = "n";
      key = "gr";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_references = false
            for _, client in pairs(clients) do
              if client.server_capabilities.referencesProvider then
                supports_references = true
                break
              end
            end
            
            if supports_references then
              require('telescope.builtin').lsp_references()
            else
              print("References not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Go to references"; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_signature = false
            for _, client in pairs(clients) do
              if client.server_capabilities.signatureHelpProvider then
                supports_signature = true
                break
              end
            end
            
            if supports_signature then
              vim.lsp.buf.signature_help()
            else
              print("Signature help not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Signature help"; };
    }
    {
      mode = "n";
      key = "<leader>rn";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_rename = false
            for _, client in pairs(clients) do
              if client.server_capabilities.renameProvider then
                supports_rename = true
                break
              end
            end
            
            if supports_rename then
              vim.lsp.buf.rename()
            else
              print("Rename not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Rename symbol"; };
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_code_action = false
            for _, client in pairs(clients) do
              if client.server_capabilities.codeActionProvider then
                supports_code_action = true
                break
              end
            end
            
            if supports_code_action then
              vim.lsp.buf.code_action()
            else
              print("Code actions not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Code action"; };
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = {
        __raw = ''
          function()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local supports_formatting = false
            for _, client in pairs(clients) do
              if client.server_capabilities.documentFormattingProvider then
                supports_formatting = true
                break
              end
            end
            
            if supports_formatting then
              vim.lsp.buf.format({ async = true })
            else
              print("Formatting not supported by current LSP server")
            end
          end
        '';
      };
      options = { desc = "Format buffer"; };
    }
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options = { desc = "Show line diagnostics"; };
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
      options = { desc = "Diagnostic loclist"; };
    }

    # Diagnostics (Trouble)
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = { desc = "Diagnostics (Trouble)"; };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options = { desc = "Buffer Diagnostics (Trouble)"; };
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<CR>";
      options = { desc = "Symbols (Trouble)"; };
    }

    # Git
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options = { desc = "LazyGit"; };
    }
    {
      mode = "n";
      key = "<leader>gj";
      action = "<cmd>lua require('gitsigns').next_hunk()<CR>";
      options = { desc = "Next git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gk";
      action = "<cmd>lua require('gitsigns').prev_hunk()<CR>";
      options = { desc = "Previous git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>lua require('gitsigns').blame_line()<CR>";
      options = { desc = "View git blame"; };
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      options = { desc = "Preview git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = "<cmd>lua require('gitsigns').reset_hunk()<CR>";
      options = { desc = "Reset git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>lua require('gitsigns').reset_buffer()<CR>";
      options = { desc = "Reset git buffer"; };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>lua require('gitsigns').stage_hunk()<CR>";
      options = { desc = "Stage git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gu";
      action = "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>";
      options = { desc = "Unstage git hunk"; };
    }

    # Terminal
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>ToggleTerm direction=float<CR>";
      options = { desc = "Toggle floating terminal"; };
    }
    {
      mode = "n";
      key = "<leader>th";
      action = "<cmd>ToggleTerm direction=horizontal<CR>";
      options = { desc = "Toggle horizontal terminal"; };
    }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>ToggleTerm direction=vertical size=80<CR>";
      options = { desc = "Toggle vertical terminal"; };
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = {
        __raw = "function() require('toggleterm.terminal').Terminal:new({cmd='node', direction='float', float_opts={border='rounded'}}):toggle() end";
      };
      options = { desc = "Node REPL"; };
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = {
        __raw = "function() require('toggleterm.terminal').Terminal:new({cmd='python3', direction='float', float_opts={border='rounded'}}):toggle() end";
      };
      options = { desc = "Python REPL"; };
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-N><C-w>h";
      options = { desc = "Terminal left window nav"; };
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-N><C-w>j";
      options = { desc = "Terminal down window nav"; };
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-N><C-w>k";
      options = { desc = "Terminal up window nav"; };
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-N><C-w>l";
      options = { desc = "Terminal right window nav"; };
    }
    {
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
      options = { desc = "Exit terminal mode"; };
    }

    # Go Development
    {
      mode = "n";
      key = "<leader>gr";
      action = {
        __raw = "function() require('toggleterm.terminal').Terminal:new({cmd='go run .', direction='horizontal', close_on_exit=false}):toggle() end";
      };
      options = { desc = "Go run"; };
    }
    {
      mode = "n";
      key = "<leader>gt";
      action = {
        __raw = "function() require('toggleterm.terminal').Terminal:new({cmd='go test -v ./...', direction='horizontal', close_on_exit=false}):toggle() end";
      };
      options = { desc = "Go test"; };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = {
        __raw = "function() require('toggleterm.terminal').Terminal:new({cmd='go build', direction='horizontal', close_on_exit=false}):toggle() end";
      };
      options = { desc = "Go build"; };
    }
    {
      mode = "n";
      key = "<leader>gtf";
      action = {
        __raw = "function() vim.cmd('GoTestFunc') end";
      };
      options = { desc = "Run test function at cursor"; };
    }

    # Telescope additional
    {
      mode = "n";
      key = "<C-p>";
      action = {
        __raw = ''
          function()
            local git_files = vim.fn.systemlist("git rev-parse --is-inside-work-tree 2>/dev/null")
            if vim.v.shell_error == 0 then
              require('telescope.builtin').git_files()
            else
              require('telescope.builtin').find_files()
            end
          end
        '';
      };
      options = { desc = "Find files (git-aware)"; };
    }
    {
      mode = "n";
      key = "<leader>*";
      action = {
        __raw = "function() require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') }) end";
      };
      options = { desc = "Search word under cursor"; };
    }
    {
      mode = "n";
      key = "<leader>/";
      action = {
        __raw = "function() require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end";
      };
      options = { desc = "Search in current buffer"; };
    }
    {
      mode = "n";
      key = "<leader>fz";
      action = "<cmd>Telescope file_browser<CR>";
      options = { desc = "File browser"; };
    }

    # Trouble additional
    {
      mode = "n";
      key = "<leader>xw";
      action = {
        __raw = "function() require('trouble').toggle('workspace_diagnostics') end";
      };
      options = { desc = "Workspace diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>xd";
      action = {
        __raw = "function() require('trouble').toggle('document_diagnostics') end";
      };
      options = { desc = "Document diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = {
        __raw = "function() require('trouble').toggle('quickfix') end";
      };
      options = { desc = "Quickfix list"; };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = {
        __raw = "function() require('trouble').toggle('loclist') end";
      };
      options = { desc = "Location list"; };
    }
    {
      mode = "n";
      key = "<leader>xr";
      action = {
        __raw = "function() require('trouble').toggle('lsp_references') end";
      };
      options = { desc = "LSP references"; };
    }
    {
      mode = "n";
      key = "]t";
      action = {
        __raw = ''
          function()
            if require('trouble').is_open() then
              require('trouble').next({skip_groups = true, jump = true})
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
      };
      options = { desc = "Next trouble item"; };
    }
    {
      mode = "n";
      key = "[t";
      action = {
        __raw = ''
          function()
            if require('trouble').is_open() then
              require('trouble').previous({skip_groups = true, jump = true})
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
      };
      options = { desc = "Previous trouble item"; };
    }

    # Git additional (gitsigns integration)
    {
      mode = "n";
      key = "]c";
      action = {
        __raw = ''
          function()
            if vim.wo.diff then 
              vim.cmd.normal({']c', bang = true})
            else
              require('gitsigns').next_hunk()
            end
          end
        '';
      };
      options = { desc = "Next git hunk"; };
    }
    {
      mode = "n";
      key = "[c";
      action = {
        __raw = ''
          function()
            if vim.wo.diff then 
              vim.cmd.normal({'[c', bang = true})
            else
              require('gitsigns').prev_hunk()
            end
          end
        '';
      };
      options = { desc = "Previous git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>hs";
      action = {
        __raw = "function() require('gitsigns').stage_hunk() end";
      };
      options = { desc = "Stage hunk"; };
    }
    {
      mode = "v";
      key = "<leader>hs";
      action = {
        __raw = "function() require('gitsigns').stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end";
      };
      options = { desc = "Stage hunk"; };
    }
    {
      mode = "n";
      key = "<leader>hr";
      action = {
        __raw = "function() require('gitsigns').reset_hunk() end";
      };
      options = { desc = "Reset hunk"; };
    }
    {
      mode = "v";
      key = "<leader>hr";
      action = {
        __raw = "function() require('gitsigns').reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end";
      };
      options = { desc = "Reset hunk"; };
    }
    {
      mode = "n";
      key = "<leader>hS";
      action = {
        __raw = "function() require('gitsigns').stage_buffer() end";
      };
      options = { desc = "Stage buffer"; };
    }
    {
      mode = "n";
      key = "<leader>hu";
      action = {
        __raw = "function() require('gitsigns').undo_stage_hunk() end";
      };
      options = { desc = "Undo stage hunk"; };
    }
    {
      mode = "n";
      key = "<leader>hR";
      action = {
        __raw = "function() require('gitsigns').reset_buffer() end";
      };
      options = { desc = "Reset buffer"; };
    }
    {
      mode = "n";
      key = "<leader>hp";
      action = {
        __raw = "function() require('gitsigns').preview_hunk() end";
      };
      options = { desc = "Preview hunk"; };
    }
    {
      mode = "n";
      key = "<leader>hb";
      action = {
        __raw = "function() require('gitsigns').blame_line{full=true} end";
      };
      options = { desc = "Blame line"; };
    }
    {
      mode = "n";
      key = "<leader>tb";
      action = {
        __raw = "function() require('gitsigns').toggle_current_line_blame() end";
      };
      options = { desc = "Toggle line blame"; };
    }
    {
      mode = "n";
      key = "<leader>hd";
      action = {
        __raw = "function() require('gitsigns').diffthis() end";
      };
      options = { desc = "Diff this"; };
    }
    {
      mode = "n";
      key = "<leader>hD";
      action = {
        __raw = "function() require('gitsigns').diffthis('~') end";
      };
      options = { desc = "Diff this ~"; };
    }
    {
      mode = "n";
      key = "<leader>td";
      action = {
        __raw = "function() require('gitsigns').toggle_deleted() end";
      };
      options = { desc = "Toggle deleted"; };
    }
    {
      mode = [ "o" "x" ];
      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      options = { desc = "Select hunk"; };
    }

    # Git conflict resolution
    {
      mode = "n";
      key = "<leader>co";
      action = "<Plug>(git-conflict-ours)";
      options = { desc = "Choose ours"; };
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<Plug>(git-conflict-theirs)";
      options = { desc = "Choose theirs"; };
    }
    {
      mode = "n";
      key = "<leader>cb";
      action = "<Plug>(git-conflict-both)";
      options = { desc = "Choose both"; };
    }
    {
      mode = "n";
      key = "<leader>c0";
      action = "<Plug>(git-conflict-none)";
      options = { desc = "Choose none"; };
    }
    {
      mode = "n";
      key = "]x";
      action = "<Plug>(git-conflict-next-conflict)";
      options = { desc = "Next conflict"; };
    }
    {
      mode = "n";
      key = "[x";
      action = "<Plug>(git-conflict-prev-conflict)";
      options = { desc = "Previous conflict"; };
    }

    # Additional utility keymaps
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>GitBlameToggle<CR>";
      options = { desc = "Toggle git blame"; };
    }
    {
      mode = "n";
      key = "<leader>gL";
      action = "<cmd>GitLog<CR>";
      options = { desc = "Git log"; };
    }
    {
      mode = "n";
      key = "<leader>gS";
      action = "<cmd>GitStatus<CR>";
      options = { desc = "Git status"; };
    }
  ];
}
