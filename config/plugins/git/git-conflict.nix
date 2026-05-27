# git-conflict.nvim — inline merge conflict resolution.
#
# Operates directly on `<<<<<<<` / `=======` / `>>>>>>>` markers; no
# panel UI to float. The plugin's defaults bind `co`/`ct`/`cb`/`c0`
# (ours/theirs/both/none) and `[x`/`]x` (prev/next conflict) inside
# conflicted buffers only — we keep those and add `<leader>gc*`
# globals so the actions surface in which-key. `<leader>gcl` opens the
# project-wide conflict list through Snacks for the floating picker UX.
{ ... }: {
  plugins.git-conflict = {
    enable = true;
    settings = {
      default_mappings = true;
      default_commands = true;
      disable_diagnostics = false;
      # GitConflictListQf populates the quickfix then calls list_opener.
      # Swapping `copen` for a Snacks picker keeps the conflict list in
      # the same floating idiom as the rest of the UI.
      list_opener = "lua Snacks.picker.qflist()";
      highlights = {
        incoming = "DiffAdd";
        current = "DiffText";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gco";
      action = "<cmd>GitConflictChooseOurs<CR>";
      options = { desc = "Conflict: choose ours"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gct";
      action = "<cmd>GitConflictChooseTheirs<CR>";
      options = { desc = "Conflict: choose theirs"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gcb";
      action = "<cmd>GitConflictChooseBoth<CR>";
      options = { desc = "Conflict: choose both"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gcn";
      action = "<cmd>GitConflictChooseNone<CR>";
      options = { desc = "Conflict: choose none"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gcl";
      action = "<cmd>GitConflictListQf<CR>";
      options = { desc = "Conflict: list project conflicts (float)"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gcN";
      action = "<cmd>GitConflictNextConflict<CR>";
      options = { desc = "Conflict: next"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gcp";
      action = "<cmd>GitConflictPrevConflict<CR>";
      options = { desc = "Conflict: previous"; silent = true; };
    }
  ];
}
