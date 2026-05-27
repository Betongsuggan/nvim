{ ... }: {
  keymaps = [
    # General editor keymaps
    {
      mode = "n";
      key = "<Esc>";
      action = {
        __raw = ''
          function()
            -- Close every focusable floating window (LSP hover, signature_help,
            -- diagnostic float, gitsigns preview, etc). Pickers/terminals have
            -- their own buffer-local <Esc>, which preempts this global handler.
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) then
                local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
                if ok and cfg.relative ~= "" and cfg.focusable ~= false then
                  pcall(vim.api.nvim_win_close, win, false)
                end
              end
            end
            vim.cmd("nohlsearch")
          end
        '';
      };
      options = { desc = "Close floats + clear search highlights"; };
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
      action = { __raw = "function() Snacks.terminal.toggle() end"; };
      options = { desc = "Toggle floating terminal"; };
    }
    {
      mode = "t";
      key = "<C-t>";
      action = { __raw = "function() Snacks.terminal.toggle() end"; };
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
      action = { __raw = "function() Snacks.bufdelete() end"; };
      options = { desc = "Delete buffer (preserve layout)"; };
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = { __raw = "function() Snacks.bufdelete({ force = true }) end"; };
      options = { desc = "Force delete buffer (preserve layout)"; };
    }
    {
      mode = "n";
      key = "<leader>br";
      action = "<cmd>checktime<CR>";
      options = { desc = "Reload: check buffer against disk"; };
    }
    {
      mode = "n";
      key = "<leader>bR";
      action = "<cmd>edit!<CR>";
      options = { desc = "Reload: discard buffer, take disk version"; };
    }
    {
      mode = "n";
      key = "<leader>bW";
      action = "<cmd>write!<CR>";
      options = { desc = "Force write: overwrite disk with buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bf";
      action = "<cmd>diffsplit %<CR>";
      options = { desc = "Diff buffer vs. disk version"; };
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = {
        __raw = "function() _G.keymap_close_other_buffers() end";
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
      key = "<leader>bb";
      action = { __raw = "function() Snacks.picker.buffers() end"; };
      options = { desc = "Buffer picker"; };
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
      mode = [ "n" "i" "t" ];
      key = "<C-h>";
      action = "<C-w>h";
      options = { desc = "Move to left window"; };
    }
    {
      mode = [ "n" "i" "t" ];
      key = "<C-j>";
      action = "<C-w>j";
      options = { desc = "Move to bottom window"; };
    }
    {
      mode = [ "n" "i" "t" ];
      key = "<C-k>";
      action = "<C-w>k";
      options = { desc = "Move to top window"; };
    }
    {
      mode = [ "n" "i" "t" ];
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

    # Find operations (snacks.picker / snacks.explorer)
    {
      mode = "n";
      key = "<leader>fe";
      action = {
        __raw = ''
          function()
            Snacks.explorer({
              layout = {
                preset = "default",
                preview = "main",
              },
            })
          end
        '';
      };
      options = { desc = "File explorer"; };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = { __raw = "function() Snacks.picker.lsp_symbols() end"; };
      options = { desc = "Symbol outline"; };
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = { __raw = "function() Snacks.picker.files() end"; };
      options = { desc = "Find files"; };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = { __raw = "function() Snacks.picker.grep() end"; };
      options = { desc = "Find by grep"; };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = { __raw = "function() Snacks.picker.buffers() end"; };
      options = { desc = "Find buffers"; };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = { __raw = "function() Snacks.picker.help() end"; };
      options = { desc = "Find help"; };
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = { __raw = "function() Snacks.picker.lsp_symbols() end"; };
      options = { desc = "Document symbols"; };
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = { __raw = "function() Snacks.picker.lsp_workspace_symbols() end"; };
      options = { desc = "Workspace symbols"; };
    }
    {
      mode = "n";
      key = "<leader>fS";
      action = { __raw = "function() Snacks.picker.lsp_workspace_symbols({ pattern = vim.fn.expand('<cword>') }) end"; };
      options = { desc = "Search symbol under cursor"; };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = { __raw = "function() Snacks.picker.recent() end"; };
      options = { desc = "Recent files"; };
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = { __raw = "function() Snacks.picker.command_history() end"; };
      options = { desc = "Command history"; };
    }
    {
      mode = "n";
      key = "<leader>fk";
      action = { __raw = "function() Snacks.picker.keymaps() end"; };
      options = { desc = "Keymaps"; };
    }

    # LSP Navigation
    {
      mode = "n";
      key = "<leader>ld";
      action = { __raw = "function() Snacks.picker.lsp_definitions() end"; };
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
      action = { __raw = "function() Snacks.picker.lsp_implementations() end"; };
      options = { desc = "Go to implementations"; };
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = { __raw = "function() Snacks.picker.lsp_references() end"; };
      options = { desc = "Find references"; };
    }
    {
      mode = "n";
      key = "<leader>lt";
      action = { __raw = "function() Snacks.picker.lsp_type_definitions() end"; };
      options = { desc = "Go to type definition"; };
    }
    {
      mode = "n";
      key = "<leader>lh";
      action = { __raw = "function() vim.lsp.buf.hover() end"; };
      options = { desc = "Hover info"; };
    }
    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>LspRestart<CR>";
      options = { desc = "LSP: restart clients for buffer"; };
    }
    {
      mode = "n";
      key = "<leader>ss";
      action = "<cmd>LspRefresh<CR>";
      options = { desc = "LSP: sync (notify of disk change)"; };
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<cmd>checkhealth vim.lsp<CR>";
      options = { desc = "LSP: health check"; };
    }

    # Code Actions
    {
      mode = "n";
      key = "<leader>ch";
      action = { __raw = "function() _G.keymap_toggle_inlay_hints() end"; };
      options = { desc = "Toggle inlay hints"; };
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = { __raw = "function() vim.lsp.buf.rename() end"; };
      options = { desc = "Rename symbol (LSP)"; };
    }
    {
      mode = "n";
      key = "<leader>cR";
      action = { __raw = "function() Snacks.rename.rename_file() end"; };
      options = { desc = "Rename current file (LSP-aware)"; };
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
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" }, diagnostics = {} },
              apply = true,
            })
          end
        '';
      };
      options = { desc = "Organize imports"; };
    }

    # Diagnostics
    {
      mode = "n";
      key = "[d";
      action = {
        __raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
      };
      options = { desc = "Previous diagnostic"; };
    }
    {
      mode = "n";
      key = "]d";
      action = {
        __raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
      };
      options = { desc = "Next diagnostic"; };
    }
    {
      mode = "n";
      key = "[e";
      action = {
        __raw = "function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true }) end";
      };
      options = { desc = "Previous error"; };
    }
    {
      mode = "n";
      key = "]e";
      action = {
        __raw = "function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true }) end";
      };
      options = { desc = "Next error"; };
    }
    {
      mode = "n";
      key = "[w";
      action = {
        __raw = "function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true }) end";
      };
      options = { desc = "Previous warning"; };
    }
    {
      mode = "n";
      key = "]w";
      action = {
        __raw = "function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true }) end";
      };
      options = { desc = "Next warning"; };
    }
    {
      mode = "n";
      key = "<leader>xe";
      action = { __raw = "function() _G.keymap_show_diagnostic() end"; };
      options = { desc = "Show diagnostic"; };
    }
    {
      mode = "n";
      key = "<leader>xa";
      action = { __raw = "function() Snacks.picker.diagnostics() end"; };
      options = { desc = "All diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>xf";
      action = { __raw = "function() Snacks.picker.diagnostics_buffer() end"; };
      options = { desc = "File diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = { desc = "Trouble diagnostics"; };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options = { desc = "Quickfix list"; };
    }
    {
      mode = "n";
      key = "<leader>xl";
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

    # Project commands
    {
      mode = "n";
      key = "<leader>pt";
      action = { __raw = "function() _G.keymap_run_tests() end"; };
      options = { desc = "Run tests"; };
    }
    {
      mode = "n";
      key = "<leader>pr";
      action = { __raw = "function() _G.keymap_run_project() end"; };
      options = { desc = "Run project"; };
    }
    {
      mode = "n";
      key = "<leader>pb";
      action = { __raw = "function() _G.keymap_build_project() end"; };
      options = { desc = "Build project"; };
    }

    # Theme switching
    {
      mode = "n";
      key = "<leader>Th";
      action = "<cmd>Themery<cr>";
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
