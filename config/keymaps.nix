{ ... }:
let
  inherit (import ./lib.nix) nmap nmapSilent luaFn;
in
{
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
      options = {
        desc = "Close floats + clear search highlights";
      };
    }
    (nmap "<leader>qq" "<cmd>q<CR>" "Quit")

    # Terminal keymaps
    (nmap "<C-t>" (luaFn "Snacks.terminal.toggle()") "Toggle floating terminal")
    {
      mode = "t";
      key = "<C-t>";
      action = {
        __raw = "function() Snacks.terminal.toggle() end";
      };
      options = {
        desc = "Toggle floating terminal";
      };
    }

    # Buffer management
    (nmap "<leader>bs" "<cmd>w<CR>" "Save buffer")
    (nmap "<leader>bd" (luaFn "Snacks.bufdelete()")
      "Delete buffer (preserve layout)"
    )
    (nmap "<leader>bD" (luaFn "Snacks.bufdelete({ force = true })")
      "Force delete buffer (preserve layout)"
    )
    (nmap "<leader>br" "<cmd>checktime<CR>" "Reload: check buffer against disk")
    (nmap "<leader>bR" "<cmd>edit!<CR>" "Reload: discard buffer, take disk version")
    (nmap "<leader>bW" "<cmd>write!<CR>" "Force write: overwrite disk with buffer")
    (nmap "<leader>bf" "<cmd>diffsplit %<CR>" "Diff buffer vs. disk version")
    (nmap "<leader>bo" (luaFn "require('config.keymaps').close_other_buffers()")
      "Close all other buffers"
    )
    (nmap "[b" "<cmd>bprevious<CR>" "Previous buffer")
    (nmap "]b" "<cmd>bnext<CR>" "Next buffer")

    # Window management
    (nmap "<leader>wv" "<cmd>vsplit<CR>" "Split window vertically")
    (nmap "<leader>wh" "<cmd>split<CR>" "Split window horizontally")
    (nmap "<leader>wc" "<cmd>close<CR>" "Close window")
    (nmap "<leader>wo" "<cmd>only<CR>" "Close all other windows")
    (nmap "<leader>ww" "<C-w>w" "Switch to next window")
    (nmap "<leader>wr" "<C-w>r" "Rotate windows")

    # Window navigation
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Move to left window";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Move to bottom window";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Move to top window";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Move to right window";
      };
    }

    # Window resizing
    (nmap "<leader>w=" "<C-w>=" "Equalize window sizes")
    (nmap "<leader>w+" "<cmd>resize +5<CR>" "Increase window height")
    (nmap "<leader>w-" "<cmd>resize -5<CR>" "Decrease window height")
    (nmap "<leader>w>" "<cmd>vertical resize +5<CR>" "Increase window width")
    (nmap "<leader>w<" "<cmd>vertical resize -5<CR>" "Decrease window width")

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
      options = {
        desc = "File explorer";
      };
    }
    (nmap "<leader>fs" (luaFn "Snacks.picker.lsp_symbols()") "Symbol outline")
    (nmap "<leader>ff" (luaFn "Snacks.picker.files()") "Find files")
    (nmap "<leader>fg" (luaFn "Snacks.picker.grep()") "Find by grep")
    (nmap "<leader>fb" (luaFn "Snacks.picker.buffers()") "Find buffers")
    (nmap "<leader>fh" (luaFn "Snacks.picker.help()") "Find help")
    (nmap "<leader>fw" (luaFn "Snacks.picker.lsp_workspace_symbols()")
      "Workspace symbols"
    )
    (nmap "<leader>fS"
      (luaFn "Snacks.picker.lsp_workspace_symbols({ pattern = vim.fn.expand('<cword>') })")
      "Search symbol under cursor"
    )
    (nmap "<leader>fr" (luaFn "Snacks.picker.recent()") "Recent files")
    (nmap "<leader>fc" (luaFn "Snacks.picker.command_history()") "Command history")
    (nmap "<leader>fk" (luaFn "Snacks.picker.keymaps()") "Keymaps")

    # LSP Navigation
    (nmap "<leader>ld" (luaFn "Snacks.picker.lsp_definitions()") "Go to definition")
    (nmap "<leader>lD" (luaFn "vim.lsp.buf.declaration()") "Go to declaration")
    (nmap "<leader>li" (luaFn "Snacks.picker.lsp_implementations()")
      "Go to implementations"
    )
    (nmap "<leader>lr" (luaFn "Snacks.picker.lsp_references()") "Find references")
    (nmap "<leader>lt" (luaFn "Snacks.picker.lsp_type_definitions()")
      "Go to type definition"
    )
    (nmap "<leader>lh" (luaFn "vim.lsp.buf.hover()") "Hover info")
    (nmap "<leader>lR" "<cmd>LspRestart<CR>" "LSP: restart clients for buffer")
    (nmap "<leader>ls" "<cmd>LspRefresh<CR>" "LSP: sync (notify of disk change)")
    (nmap "<leader>lH" "<cmd>checkhealth vim.lsp<CR>" "LSP: health check")

    # Code Actions
    (nmap "<leader>ch" (luaFn "require('config.keymaps').toggle_inlay_hints()")
      "Toggle inlay hints"
    )
    (nmap "<leader>cr" (luaFn "vim.lsp.buf.rename()") "Rename symbol (LSP)")
    (nmap "<leader>cR" (luaFn "Snacks.rename.rename_file()")
      "Rename current file (LSP-aware)"
    )
    (nmap "<leader>ca" (luaFn "vim.lsp.buf.code_action()") "Code actions")
    (nmap "<leader>cf" (luaFn "vim.lsp.buf.format()") "Format code")
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
      options = {
        desc = "Organize imports";
      };
    }

    # Diagnostics
    (nmap "[d" (luaFn "vim.diagnostic.jump({ count = -1, float = true })")
      "Previous diagnostic"
    )
    (nmap "]d" (luaFn "vim.diagnostic.jump({ count = 1, float = true })")
      "Next diagnostic"
    )
    (nmap "[e"
      (luaFn "vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })")
      "Previous error"
    )
    (nmap "]e"
      (luaFn "vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })")
      "Next error"
    )
    (nmap "[w"
      (luaFn "vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })")
      "Previous warning"
    )
    (nmap "]w"
      (luaFn "vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })")
      "Next warning"
    )
    (nmap "<leader>xe" (luaFn "require('config.keymaps').show_diagnostic()")
      "Show diagnostic"
    )
    (nmap "<leader>xa" (luaFn "Snacks.picker.diagnostics()") "All diagnostics")
    (nmap "<leader>xf" (luaFn "Snacks.picker.diagnostics_buffer()")
      "File diagnostics"
    )
    (nmap "<leader>xx" "<cmd>Trouble diagnostics toggle<CR>" "Trouble diagnostics")
    (nmap "<leader>xq" "<cmd>Trouble qflist toggle<CR>" "Quickfix list")
    (nmap "<leader>xl" "<cmd>Trouble loclist toggle<CR>" "Location list")

    # Git hunk navigation and actions
    (nmap "]h" (luaFn "require('gitsigns').next_hunk()") "Next git hunk")
    (nmap "[h" (luaFn "require('gitsigns').prev_hunk()") "Previous git hunk")
    (nmap "<leader>gh" (luaFn "require('gitsigns').preview_hunk()")
      "Preview git hunk"
    )
    (nmap "<leader>gs" (luaFn "require('gitsigns').stage_hunk()") "Stage git hunk")
    (nmap "<leader>gu" (luaFn "require('gitsigns').undo_stage_hunk()")
      "Undo stage git hunk"
    )
    (nmapSilent "<leader>gX" "<cmd>GitRefresh<CR>"
      "Refresh git state (gitsigns/conflicts/diffview)"
    )

    # Project commands
    (nmap "<leader>pt" (luaFn "require('config.keymaps').run_tests()") "Run tests")
    (nmap "<leader>pr" (luaFn "require('config.keymaps').run_project()")
      "Run project"
    )
    (nmap "<leader>pb" (luaFn "require('config.keymaps').build_project()")
      "Build project"
    )

    # Claude Code keymaps
    (nmap "<C-a>" "<cmd>ClaudeCode<cr>" "Toggle Claude")
    (nmap "<C-b>" "<cmd>ClaudeCodeAdd %<cr>" "Add current buffer")
    {
      mode = "v";
      key = "<C-s>";
      action = "<cmd>ClaudeCodeSend<cr>";
      options = {
        desc = "Send to Claude";
      };
    }
    (nmap "<C-y>" "<cmd>ClaudeCodeDiffAccept<cr>" "Accept diff")
    (nmap "<C-n>" "<cmd>ClaudeCodeDiffDeny<cr>" "Deny diff")
    {
      mode = "t";
      key = "<C-a>";
      action = "<cmd>ClaudeCode<cr>";
      options = {
        desc = "Toggle Claude from terminal";
      };
    }
  ];
}
