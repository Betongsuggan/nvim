# diffview.nvim — full-screen tab-based diff/history browser.
# This is the "Path A" companion to the custom floating diff in
# floating-diff.nix: use it for branch comparison, file history, and
# the merge tool. It is architecturally locked to a tabpage and cannot
# be wrapped in a floating window — closing the tab (or running
# `:DiffviewClose`) returns to the previous layout intact.
{ ... }: {
  plugins.diffview = {
    enable = true;
    settings = {
      enhanced_diff_hl = true;
      use_icons = true;
      view = {
        default = {
          layout = "diff2_horizontal";
          winbar_info = false;
        };
        merge_tool = {
          layout = "diff3_horizontal";
          disable_diagnostics = true;
        };
        file_history = {
          layout = "diff2_horizontal";
        };
      };
      file_panel = {
        listing_style = "tree";
        tree_options = {
          flatten_dirs = true;
          folder_statuses = "only_folded";
        };
        win_config = {
          position = "left";
          width = 35;
        };
      };
      file_history_panel = {
        win_config = {
          position = "bottom";
          height = 16;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewOpen<CR>";
      options = { desc = "Diffview: working tree vs HEAD"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gR";
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Diffview against ref: ", default = "HEAD" }, function(rev)
            if rev and rev ~= "" then
              vim.cmd("DiffviewOpen " .. rev)
            end
          end)
        end
      '';
      options = { desc = "Diffview: working tree vs <ref>"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gH";
      action = "<cmd>DiffviewFileHistory %<CR>";
      options = { desc = "Diffview: history of current file"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gL";
      action = "<cmd>DiffviewFileHistory<CR>";
      options = { desc = "Diffview: history of branch"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gq";
      action = "<cmd>DiffviewClose<CR>";
      options = { desc = "Diffview: close current view"; silent = true; };
    }
  ];
}
