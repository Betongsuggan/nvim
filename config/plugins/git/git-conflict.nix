# git-conflict.nvim — inline merge conflict resolution.
#
# Operates directly on `<<<<<<<` / `=======` / `>>>>>>>` markers; no
# panel UI to float. The plugin's defaults bind `co`/`ct`/`cb`/`c0`
# (ours/theirs/both/none) and `[x`/`]x` (prev/next conflict) inside
# conflicted buffers only — we keep those and add `<leader>gc*`
# globals so the actions surface in which-key. `<leader>gcl` opens the
# project-wide conflict list through Snacks for the floating picker UX.
{ ... }:
let
  inherit (import ../../lib.nix) nmapSilent;
in
{
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
    (nmapSilent "<leader>gco" "<cmd>GitConflictChooseOurs<CR>"
      "Conflict: choose ours"
    )
    (nmapSilent "<leader>gct" "<cmd>GitConflictChooseTheirs<CR>"
      "Conflict: choose theirs"
    )
    (nmapSilent "<leader>gcb" "<cmd>GitConflictChooseBoth<CR>"
      "Conflict: choose both"
    )
    (nmapSilent "<leader>gcn" "<cmd>GitConflictChooseNone<CR>"
      "Conflict: choose none"
    )
    (nmapSilent "<leader>gcl" "<cmd>GitConflictListQf<CR>"
      "Conflict: list project conflicts (float)"
    )
    (nmapSilent "<leader>gcN" "<cmd>GitConflictNextConflict<CR>" "Conflict: next")
    (nmapSilent "<leader>gcp" "<cmd>GitConflictPrevConflict<CR>"
      "Conflict: previous"
    )
  ];
}
