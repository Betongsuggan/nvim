# snacks.nvim: pickers, explorer, terminal, notifications, input, status
# column, scope highlight, and helpers (bufdelete, rename, toggles, git
# browse) used by the keymaps.
{ utils, ... }:
{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      quickfile.enabled = true;
      input.enabled = true;
      words.enabled = true;
      toggle.enabled = true;
      gitbrowse.enabled = true;
      picker = {
        enabled = true;
        ui_select = true;
      };
      # Highlight the scope at the cursor, no indent guides or animation
      indent = {
        enabled = true;
        indent.enabled = false;
        animate.enabled = false;
        scope.enabled = true;
      };
      # The notifier and the status column each run a timer for as long as
      # nvim does (50 ms by default: ~40 idle wake-ups/s together). Slowing
      # them only delays a notification or a sign change by up to 0.5 / 0.25 s.
      notifier = {
        enabled = true;
        timeout = 3000;
        refresh = 500;
      };
      statuscolumn = {
        enabled = true;
        refresh = 250;
        left = [
          "mark"
          "sign"
        ];
        right = [
          "fold"
          "git"
        ];
        git.patterns = [ "GitSign" ];
      };
      terminal = {
        enabled = true;
        win = utils.floatTerminalWin;
      };
    };
  };
}
