# Ergonomic plugins: flash, grug-far, persistence.
{ ... }:
let
  inherit (import ../../lib.nix) nmap luaFn;
in
{
  plugins = {
    # flash.nvim: treesitter-aware motions
    flash = {
      enable = true;
      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        modes = {
          char = {
            enabled = true;
            jump_labels = true;
          };
          search = {
            enabled = false;
          };
        };
      };
    };

    # Project-wide search & replace with live preview, per-result opt-out.
    grug-far = {
      enable = true;
    };

    # (undotree replaced by Snacks.picker.undo — floating picker with diff preview)

    # Per-cwd session restore (buffers, layout, cursor).
    persistence = {
      enable = true;
      settings = {
        options = [
          "buffers"
          "curdir"
          "tabpages"
          "winsize"
          "help"
          "globals"
          "skiprtp"
        ];
      };
    };
  };

  keymaps = [
    # flash.nvim motions
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "s";
      action = {
        __raw = "function() require('flash').jump() end";
      };
      options = {
        desc = "Flash jump";
      };
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "S";
      action = {
        __raw = "function() require('flash').treesitter() end";
      };
      options = {
        desc = "Flash treesitter";
      };
    }
    {
      mode = "o";
      key = "r";
      action = {
        __raw = "function() require('flash').remote() end";
      };
      options = {
        desc = "Flash remote operation";
      };
    }
    {
      mode = [
        "o"
        "x"
      ];
      key = "R";
      action = {
        __raw = "function() require('flash').treesitter_search() end";
      };
      options = {
        desc = "Flash treesitter search";
      };
    }
    {
      mode = "c";
      key = "<C-s>";
      action = {
        __raw = "function() require('flash').toggle() end";
      };
      options = {
        desc = "Toggle Flash search";
      };
    }

    # grug-far: project-wide search/replace
    (nmap "<leader>R" "<cmd>GrugFar<cr>" "Search & replace (grug-far)")
    {
      mode = "v";
      key = "<leader>R";
      action = "<esc><cmd>GrugFar<cr>";
      options = {
        desc = "Search & replace (grug-far)";
      };
    }

    # Undo history (snacks.picker — floating picker with diff preview)
    (nmap "<leader>u" (luaFn "Snacks.picker.undo()") "Undo history")

    # persistence: session restore
    (nmap "<leader>qs" (luaFn "require('persistence').load()")
      "Restore session for cwd"
    )
    (nmap "<leader>ql" (luaFn "require('persistence').load({ last = true })")
      "Restore last session"
    )
    (nmap "<leader>qd" (luaFn "require('persistence').stop()")
      "Don't save current session"
    )
  ];

  extraConfigLua = ''
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
