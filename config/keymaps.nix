{ ... }: {
  keymaps = [
    # General editor keymaps
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = { desc = "Clear search highlights"; };
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>q<CR>";
      options = { desc = "Quit"; };
    }

    # Buffer management
    {
      mode = "n";
      key = "<leader>bs";
      action = "<cmd>w<CR>";
      options = { desc = "Save buffer"; };
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
      mode = "n";
      key = "<leader>bo";
      action = {
        __raw = "function() vim.cmd('%bdelete|edit#|bdelete#') end";
      };
      options = { desc = "Close all other buffers"; };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<CR>";
      options = { desc = "Next buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bnext<CR>";
      options = { desc = "Next buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>bprevious<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bc";
      action = {
        __raw = "function() require('bufferline').pick_buffer() end";
      };
      options = { desc = "Pick buffer to switch to"; };
    }

    # Window management
    {
      mode = "n";
      key = "<leader>wv";
      action = "<cmd>vsplit<CR>";
      options = { desc = "Split window vertically"; };
    }
    {
      mode = "n";
      key = "<leader>wh";
      action = "<cmd>split<CR>";
      options = { desc = "Split window horizontally"; };
    }
    {
      mode = "n";
      key = "<leader>wc";
      action = "<cmd>close<CR>";
      options = { desc = "Close window"; };
    }
    {
      mode = "n";
      key = "<leader>wo";
      action = "<cmd>only<CR>";
      options = { desc = "Close all other windows"; };
    }
    {
      mode = "n";
      key = "<leader>ww";
      action = "<C-w>w";
      options = { desc = "Switch to next window"; };
    }
    {
      mode = "n";
      key = "<leader>wr";
      action = "<C-w>r";
      options = { desc = "Rotate windows"; };
    }

    # Window navigation
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

    # Window resizing
    {
      mode = "n";
      key = "<leader>w=";
      action = "<C-w>=";
      options = { desc = "Equalize window sizes"; };
    }
    {
      mode = "n";
      key = "<leader>w+";
      action = "<cmd>resize +5<CR>";
      options = { desc = "Increase window height"; };
    }
    {
      mode = "n";
      key = "<leader>w-";
      action = "<cmd>resize -5<CR>";
      options = { desc = "Decrease window height"; };
    }
    {
      mode = "n";
      key = "<leader>w>";
      action = "<cmd>vertical resize +5<CR>";
      options = { desc = "Increase window width"; };
    }
    {
      mode = "n";
      key = "<leader>w<";
      action = "<cmd>vertical resize -5<CR>";
      options = { desc = "Decrease window width"; };
    }

    # Find operations (using <leader>f prefix - Telescope)
    {
      mode = "n";
      key = "<leader>fe";
      action = {
        __raw = ''
          function()
            local current_file = vim.fn.expand('%:p')
            if current_file and current_file ~= "" then
              -- If there's a current file, reveal it in neo-tree
              vim.cmd("Neotree toggle reveal")
            else
              -- If no current file, just toggle normally
              vim.cmd("Neotree toggle")
            end
          end
        '';
      };
      options = { desc = "File explorer"; };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>AerialToggle<CR>";
      options = { desc = "Symbol outline"; };
    }
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
      options = { desc = "Find by grep"; };
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
      options = { desc = "Find help"; };
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = "<cmd>Telescope lsp_document_symbols<CR>";
      options = { desc = "Document symbols"; };
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>Telescope lsp_workspace_symbols<CR>";
      options = { desc = "Workspace symbols"; };
    }

    # Code actions (LSP, formatting, etc. under <leader>c prefix)
    {
      mode = "n";
      key = "<leader>cd";
      action = {
        __raw = "function() require('telescope.builtin').lsp_definitions() end";
      };
      options = { desc = "Go to definition"; };
    }
    {
      mode = "n";
      key = "<leader>cD";
      action = {
        __raw = "function() vim.lsp.buf.declaration() end";
      };
      options = { desc = "Go to declaration"; };
    }
    {
      mode = "n";
      key = "<leader>ci";
      action = {
        __raw = "function() require('telescope.builtin').lsp_implementations() end";
      };
      options = { desc = "Go to implementations"; };
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = {
        __raw = "function() require('telescope.builtin').lsp_references() end";
      };
      options = { desc = "Find references"; };
    }
    {
      mode = "n";
      key = "<leader>ch";
      action = {
        __raw = "function() vim.lsp.buf.hover() end";
      };
      options = { desc = "Hover info"; };
    }
    {
      mode = "n";
      key = "<leader>cn";
      action = {
        __raw = ''
          function()
            local current_name = vim.fn.expand('<cword>')
            
            -- Create input buffer
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { current_name })
            
            -- Calculate popup size and position
            local width = math.max(30, string.len(current_name) + 10)
            local height = 1
            local win_opts = {
              relative = "cursor",
              width = width,
              height = height,
              row = 1,
              col = 0,
              style = "minimal",
              border = "rounded",
              title = " Rename Symbol ",
              title_pos = "center"
            }
            
            -- Create floating window
            local win = vim.api.nvim_open_win(buf, true, win_opts)
            
            -- Set up the buffer for input
            vim.bo[buf].filetype = "text"
            vim.wo[win].cursorline = false
            
            -- Position cursor at end of text and start insert mode
            vim.api.nvim_win_set_cursor(win, {1, string.len(current_name)})
            vim.cmd("startinsert!")  -- startinsert! puts cursor at end of line
            
            -- Set up keymaps for the rename popup
            local function rename_and_close()
              local new_name = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
              vim.api.nvim_win_close(win, true)
              if new_name and new_name ~= current_name and new_name ~= "" then
                vim.lsp.buf.rename(new_name)
              end
            end
            
            local function close_popup()
              vim.api.nvim_win_close(win, true)
            end
            
            -- Keymaps for the popup
            vim.keymap.set({"n", "i"}, "<CR>", rename_and_close, { buffer = buf })
            vim.keymap.set("n", "q", close_popup, { buffer = buf })
            
            -- Smart Escape behavior: insert mode -> normal mode, normal mode -> exit
            vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = buf })  -- Insert to normal mode
            vim.keymap.set("n", "<Esc>", close_popup, { buffer = buf })  -- Normal mode exits
            
            -- Allow normal vim mode switching behavior
            vim.keymap.set("i", "<C-c>", close_popup, { buffer = buf })  -- Alternative exit from insert
            vim.keymap.set("n", "i", "i", { buffer = buf })  -- Allow entering insert mode
            vim.keymap.set("n", "a", "a", { buffer = buf })  -- Allow append
            vim.keymap.set("n", "A", "A", { buffer = buf })  -- Allow append at end
          end
        '';
      };
      options = { desc = "Rename symbol"; };
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = {
        __raw = "function() vim.lsp.buf.code_action() end";
      };
      options = { desc = "Code actions"; };
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = {
        __raw = "function() vim.lsp.buf.format() end";
      };
      options = { desc = "Format code"; };
    }
    {
      mode = "n";
      key = "<leader>co";
      action = {
        __raw = ''
          function()
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                end
              end
            end
          end
        '';
      };
      options = { desc = "Organize imports"; };
    }

    # Diagnostic keymaps
    {
      mode = "n";
      key = "[d";
      action = {
        __raw = "function() vim.diagnostic.goto_prev({ border = 'rounded' }) end";
      };
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = {
        __raw = "function() vim.diagnostic.goto_next({ border = 'rounded' }) end";
      };
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "[e";
      action = {
        __raw = "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, border = 'rounded' }) end";
      };
      options = { desc = "Previous error"; };
    }
    {
      mode = "n";
      key = "]e";
      action = {
        __raw = "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, border = 'rounded' }) end";
      };
      options = { desc = "Next error"; };
    }
    {
      mode = "n";
      key = "[w";
      action = {
        __raw = "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, border = 'rounded' }) end";
      };
      options = { desc = "Previous warning"; };
    }
    {
      mode = "n";
      key = "]w";
      action = {
        __raw = "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, border = 'rounded' }) end";
      };
      options = { desc = "Next warning"; };
    }
    {
      mode = "n";
      key = "<leader>ce";
      action = {
        __raw = ''
          function() 
            vim.diagnostic.open_float({
              border = "rounded",
              source = "always",
              header = "",
              prefix = "",
              focusable = true,
              style = "minimal"
            })
          end
        '';
      };
      options = { desc = "Show diagnostic"; };
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = {
        __raw = "function() _G.telescope_diagnostics_with_preview() end";
      };
      options = { desc = "All diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>cT";
      action = "<cmd>Telescope diagnostics bufnr=0<CR>";
      options = { desc = "Buffer diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>cx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = { desc = "Trouble diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>cq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options = { desc = "Quickfix list"; };
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options = { desc = "Location list"; };
    }

    # Git hunk navigation and actions
    {
      mode = "n";
      key = "]h";
      action = {
        __raw = "function() require('gitsigns').next_hunk() end";
      };
      options = { desc = "Next git hunk"; };
    }
    {
      mode = "n";
      key = "[h";
      action = {
        __raw = "function() require('gitsigns').prev_hunk() end";
      };
      options = { desc = "Previous git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = {
        __raw = "function() require('gitsigns').preview_hunk() end";
      };
      options = { desc = "Preview git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = {
        __raw = "function() require('gitsigns').stage_hunk() end";
      };
      options = { desc = "Stage git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gu";
      action = {
        __raw = "function() require('gitsigns').undo_stage_hunk() end";
      };
      options = { desc = "Undo stage git hunk"; };
    }

    # Project commands (language-agnostic using <leader>p prefix)
    {
      mode = "n";
      key = "<leader>pt";
      action = {
        __raw = ''
          function()
            -- Detect project type and run appropriate test command
            if vim.fn.filereadable("go.mod") == 1 then
              vim.cmd("!go test ./...")
            elseif vim.fn.filereadable("package.json") == 1 then
              vim.cmd("!npm test")
            elseif vim.fn.filereadable("Cargo.toml") == 1 then
              vim.cmd("!cargo test")
            elseif vim.fn.filereadable("Makefile") == 1 then
              vim.cmd("!make test")
            else
              print("No recognized test framework found")
            end
          end
        '';
      };
      options = { desc = "Run tests"; };
    }
    {
      mode = "n";
      key = "<leader>pr";
      action = {
        __raw = ''
          function()
            -- Detect project type and run appropriate run command
            if vim.fn.filereadable("go.mod") == 1 then
              vim.cmd("!go run .")
            elseif vim.fn.filereadable("package.json") == 1 then
              vim.cmd("!npm start")
            elseif vim.fn.filereadable("Cargo.toml") == 1 then
              vim.cmd("!cargo run")
            elseif vim.fn.filereadable("Makefile") == 1 then
              vim.cmd("!make run")
            else
              print("No recognized run command found")
            end
          end
        '';
      };
      options = { desc = "Run project"; };
    }
    {
      mode = "n";
      key = "<leader>pb";
      action = {
        __raw = ''
          function()
            -- Detect project type and run appropriate build command
            if vim.fn.filereadable("go.mod") == 1 then
              vim.cmd("!go build")
            elseif vim.fn.filereadable("package.json") == 1 then
              vim.cmd("!npm run build")
            elseif vim.fn.filereadable("Cargo.toml") == 1 then
              vim.cmd("!cargo build")
            elseif vim.fn.filereadable("Makefile") == 1 then
              vim.cmd("!make build")
            else
              print("No recognized build command found")
            end
          end
        '';
      };
      options = { desc = "Build project"; };
    }

    # Theme switching
    {
      mode = "n";
      key = "<leader>th";
      action = {
        __raw = ''
          function()
            print("Current theme configuration is managed in config/theme.nix")
            print("Available themes: catppuccin, gruvbox")
            print("Edit 'currentThemeName' in theme.nix and rebuild to switch themes")
          end
        '';
      };
      options = { desc = "Theme help"; };
    }
  ];
}