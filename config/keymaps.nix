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

    # Terminal keymaps
    {
      mode = "n";
      key = "<C-t>";
      action = "<cmd>ToggleTerm<cr>";
      options = { desc = "Toggle floating terminal"; };
    }
    {
      mode = "t";
      key = "<C-t>";
      action = "<cmd>ToggleTerm<cr>";
      options = { desc = "Toggle floating terminal"; };
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
        __raw = ''
          function() 
            local current_buf = vim.api.nvim_get_current_buf()
            local buffers = vim.api.nvim_list_bufs()
            for _, buf in ipairs(buffers) do
              if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
                local buf_name = vim.api.nvim_buf_get_name(buf)
                local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
                local buf_filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
                
                -- Skip terminal buffers, special buffer types, and toggleterm
                local is_terminal = buf_type == 'terminal' or 
                                    buf_name:match('^term://') or 
                                    buf_filetype == 'toggleterm' or
                                    buf_name:match('toggleterm')
                
                if not is_terminal then
                  pcall(vim.api.nvim_buf_delete, buf, {force = false})
                end
              end
            end
          end
        '';
      };
      options = { desc = "Close all other buffers"; };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options = { desc = "Previous buffer"; };
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>BufferLineCycleNext<CR>";
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
      mode = ["n" "i" "t"];
      key = "<C-h>";
      action = "<C-w>h";
      options = { desc = "Move to left window"; };
    }
    {
      mode = ["n" "i" "t"];
      key = "<C-j>";
      action = "<C-w>j";
      options = { desc = "Move to bottom window"; };
    }
    {
      mode = ["n" "i" "t"];
      key = "<C-k>";
      action = "<C-w>k";
      options = { desc = "Move to top window"; };
    }
    {
      mode = ["n" "i" "t"];
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
      action = {
        __raw = ''
          function()
            require('telescope.builtin').lsp_document_symbols({
              prompt_title = "Symbol Outline",
              results_title = "Symbols",
              preview_title = "Preview",
              layout_strategy = "center",
              layout_config = {
                center = {
                  width = 0.8,
                  height = 0.8,
                  preview_cutoff = 40,
                },
              },
              sorting_strategy = "ascending",
              symbols = {
                "Class", "Constructor", "Enum", "Function", 
                "Interface", "Module", "Method", "Struct",
                "Variable", "Field", "Property", "Constant"
              },
            })
          end
        '';
      };
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
    {
      mode = "n";
      key = "<leader>fS";
      action = {
        __raw = ''
          function()
            require('telescope.builtin').lsp_workspace_symbols({
              prompt_title = "Search Symbols",
              results_title = "Symbol Results", 
              preview_title = "Preview",
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = {
                  prompt_position = "top",
                  preview_width = 0.5,
                },
              },
              sorting_strategy = "ascending",
              query = vim.fn.expand('<cword>'),
            })
          end
        '';
      };
      options = { desc = "Search symbols"; };
    }

    # LSP Navigation (using <leader>l prefix for Language features)
    {
      mode = "n";
      key = "<leader>ld";
      action = {
        __raw = "function() require('telescope.builtin').lsp_definitions() end";
      };
      options = { desc = "Go to definition"; };
    }
    {
      mode = "n";
      key = "<leader>lD";
      action = { __raw = "function() vim.lsp.buf.declaration() end"; };
      options = { desc = "Go to declaration"; };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = {
        __raw = ''
          function() 
            require('telescope.builtin').lsp_implementations({
              show_line = false,
              trim_text = true,
              include_declaration = false,
              include_current_line = false,
              layout_strategy = "horizontal",
              layout_config = {
                preview_width = 0.5,
                horizontal = {
                  prompt_position = "top",
                },
              },
              sorting_strategy = "ascending",
              results_title = "Implementations",
              prompt_title = "Search Implementations",
              preview_title = "Preview",
            })
          end
        '';
      };
      options = { desc = "Go to implementations"; };
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = {
        __raw = "function() require('telescope.builtin').lsp_references() end";
      };
      options = { desc = "Find references"; };
    }
    {
      mode = "n";
      key = "<leader>lh";
      action = { __raw = "function() vim.lsp.buf.hover() end"; };
      options = { desc = "Hover info"; };
    }
    # Code Actions (using <leader>c prefix for Code operations)
    {
      mode = "n";
      key = "<leader>ch";
      action = {
        __raw = ''
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end
          end
        '';
      };
      options = { desc = "Toggle inlay hints"; };
    }
    {
      mode = "n";
      key = "<leader>cr";
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
      action = { __raw = "function() vim.lsp.buf.code_action() end"; };
      options = { desc = "Code actions"; };
    }
    {
      mode = "n";
      key = "<leader>cf";
      action = { __raw = "function() vim.lsp.buf.format() end"; };
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

    # Diagnostics (using <leader>d prefix for Diagnostics)
    {
      mode = "n";
      key = "[d";
      action = {
        __raw =
          "function() vim.diagnostic.goto_prev({ border = 'rounded' }) end";
      };
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = {
        __raw =
          "function() vim.diagnostic.goto_next({ border = 'rounded' }) end";
      };
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "[e";
      action = {
        __raw =
          "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, border = 'rounded' }) end";
      };
      options = { desc = "Previous error"; };
    }
    {
      mode = "n";
      key = "]e";
      action = {
        __raw =
          "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, border = 'rounded' }) end";
      };
      options = { desc = "Next error"; };
    }
    {
      mode = "n";
      key = "[w";
      action = {
        __raw =
          "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, border = 'rounded' }) end";
      };
      options = { desc = "Previous warning"; };
    }
    {
      mode = "n";
      key = "]w";
      action = {
        __raw =
          "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, border = 'rounded' }) end";
      };
      options = { desc = "Next warning"; };
    }
    {
      mode = "n";
      key = "<leader>de";
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
      key = "<leader>da";
      action = {
        __raw = "function() _G.telescope_diagnostics_with_preview() end";
      };
      options = { desc = "All diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>df";
      action = "<cmd>Telescope diagnostics bufnr=0<CR>";
      options = { desc = "File diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>dx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = { desc = "Trouble diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>dq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options = { desc = "Quickfix list"; };
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options = { desc = "Location list"; };
    }

    # Git hunk navigation and actions
    {
      mode = "n";
      key = "]h";
      action = { __raw = "function() require('gitsigns').next_hunk() end"; };
      options = { desc = "Next git hunk"; };
    }
    {
      mode = "n";
      key = "[h";
      action = { __raw = "function() require('gitsigns').prev_hunk() end"; };
      options = { desc = "Previous git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = { __raw = "function() require('gitsigns').preview_hunk() end"; };
      options = { desc = "Preview git hunk"; };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = { __raw = "function() require('gitsigns').stage_hunk() end"; };
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
      key = "<leader>Th";
      action = { __raw = "function() _G.theme_picker() end"; };
      options = { desc = "Theme picker"; };
    }

    # Claude Code keymaps
    {
      mode = "n";
      key = "<C-a>";
      action = "<cmd>ClaudeCode<cr>";
      options = { desc = "Toggle Claude"; };
    }
    {
      mode = "n";
      key = "<C-b>";
      action = "<cmd>ClaudeCodeAdd %<cr>";
      options = { desc = "Add current buffer"; };
    }
    {
      mode = "v";
      key = "<C-s>";
      action = "<cmd>ClaudeCodeSend<cr>";
      options = { desc = "Send to Claude"; };
    }
    {
      mode = "n";
      key = "<C-y>";
      action = "<cmd>ClaudeCodeDiffAccept<cr>";
      options = { desc = "Accept diff"; };
    }
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>ClaudeCodeDiffDeny<cr>";
      options = { desc = "Deny diff"; };
    }
    {
      mode = "t";
      key = "<C-a>";
      action = "<cmd>ClaudeCode<cr>";
      options = { desc = "Toggle Claude from terminal"; };
    }
  ];
}

