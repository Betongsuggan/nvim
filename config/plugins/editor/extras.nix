# Phase 5 ergonomic plugins: flash, grug-far, undotree, themery, persistence.
{ pkgs ? null, ... }: {
  plugins = {
    # Project-wide search & replace with live preview, per-result opt-out.
    grug-far = {
      enable = true;
    };

    # (undotree replaced by Snacks.picker.undo — floating picker with diff preview)

    # Per-cwd session restore (buffers, layout, cursor).
    persistence = {
      enable = true;
      settings = {
        options = [ "buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" ];
      };
    };
  };

  # flash.nvim and themery.nvim aren't exposed as nixvim module wrappers,
  # so we install them as raw plugins and configure them in Lua.
  extraPlugins = if pkgs == null then [ ] else
    [ pkgs.vimPlugins.flash-nvim pkgs.vimPlugins.themery-nvim ];

  keymaps = [
    # flash.nvim motions
    {
      mode = [ "n" "x" "o" ];
      key = "s";
      action = { __raw = "function() require('flash').jump() end"; };
      options = { desc = "Flash jump"; };
    }
    {
      mode = [ "n" "x" "o" ];
      key = "S";
      action = { __raw = "function() require('flash').treesitter() end"; };
      options = { desc = "Flash treesitter"; };
    }
    {
      mode = "o";
      key = "r";
      action = { __raw = "function() require('flash').remote() end"; };
      options = { desc = "Flash remote operation"; };
    }
    {
      mode = [ "o" "x" ];
      key = "R";
      action = { __raw = "function() require('flash').treesitter_search() end"; };
      options = { desc = "Flash treesitter search"; };
    }
    {
      mode = "c";
      key = "<C-s>";
      action = { __raw = "function() require('flash').toggle() end"; };
      options = { desc = "Toggle Flash search"; };
    }

    # grug-far: project-wide search/replace
    {
      mode = "n";
      key = "<leader>R";
      action = "<cmd>GrugFar<cr>";
      options = { desc = "Search & replace (grug-far)"; };
    }
    {
      mode = "v";
      key = "<leader>R";
      action = "<esc><cmd>GrugFar<cr>";
      options = { desc = "Search & replace (grug-far)"; };
    }

    # Undo history (snacks.picker — floating picker with diff preview)
    {
      mode = "n";
      key = "<leader>u";
      action = { __raw = "function() Snacks.picker.undo() end"; };
      options = { desc = "Undo history"; };
    }

    # persistence: session restore
    {
      mode = "n";
      key = "<leader>qs";
      action = { __raw = "function() require('persistence').load() end"; };
      options = { desc = "Restore session for cwd"; };
    }
    {
      mode = "n";
      key = "<leader>ql";
      action = { __raw = "function() require('persistence').load({ last = true }) end"; };
      options = { desc = "Restore last session"; };
    }
    {
      mode = "n";
      key = "<leader>qd";
      action = { __raw = "function() require('persistence').stop() end"; };
      options = { desc = "Don't save current session"; };
    }
  ];

  extraConfigLua = ''
    -- flash.nvim: treesitter-aware motions
    require('flash').setup({
      labels = "asdfghjklqwertyuiopzxcvbnm",
      modes = {
        char = { enabled = true, jump_labels = true },
        search = { enabled = false },
      },
    })

    -- themery.nvim: theme switcher with live preview + persistence
    require('themery').setup({
      themes = {
        "catppuccin",
        "gruvbox",
        "tokyonight",
        "nord",
        "onedark",
        "nightfox",
        "dracula",
        "kanagawa",
        "rose-pine",
      },
      livePreview = true,
    })

    -- Auto-restore the per-cwd session on bare nvim startup (no file args).
    local persistence_grp = vim.api.nvim_create_augroup("PersistenceAutoload", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = persistence_grp,
      pattern = "*",
      nested = true,
      callback = function()
        if vim.fn.argc() == 0 and vim.fn.bufname() == "" then
          require("persistence").load()
        end
      end,
    })
  '';
}
