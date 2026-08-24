# snacks.nvim — picker/explorer/terminal/notifier/rename/bufdelete replace
# telescope, neo-tree, toggleterm, and a pile of custom Lua. `terminal` and
# `win` were already on for claudecode.nvim; everything else is now real.
{ ... }:
{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      dashboard.enabled = false;
      indent = {
        enabled = true;
        indent = {
          enabled = false;
        }; # no full-height indent guide lines
        scope = {
          enabled = true;
        }; # keep the scope highlight at the cursor
      };
      input.enabled = true;
      notifier = {
        enabled = true;
        timeout = 3000;
      };
      picker = {
        enabled = true;
        ui_select = true;
        layout = {
          preset = "default";
        };
      };
      quickfile.enabled = true;
      scope.enabled = false;
      scroll.enabled = false;
      statuscolumn = {
        enabled = true;
        left = [
          "mark"
          "sign"
        ];
        right = [
          "fold"
          "git"
        ];
        git = {
          patterns = [
            "GitSign"
            "MiniDiffSign"
          ];
        };
      };
      words.enabled = true;
      terminal = {
        enabled = true;
        win = {
          position = "float";
          width = 0.9;
          height = 0.9;
          border = "rounded";
          wo = {
            scrolloff = 0;
            sidescrolloff = 0;
          };
        };
      };
      win.enabled = true;
    };
  };
}
