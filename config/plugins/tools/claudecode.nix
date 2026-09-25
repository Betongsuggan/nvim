# claudecode.nvim — Claude Code integration (IDE server + diff review).
{ utils, ... }:
{
  plugins.claudecode = {
    enable = true;
    # Its IDE server starts once the UI is up, not during startup
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = {
      # The IDE server Claude Code connects to; its only timer is a 30 s ping
      auto_start = true;
      log_level = "info";

      terminal = {
        provider = "snacks";
        auto_close = false;
        snacks_win_opts = utils.floatTerminalWin;
      };

      diff_opts = {
        auto_close_on_accept = true;
        auto_close_on_reject = true;
        vertical_split = false;
        close_other_windows = false;
        focus_diff_window = true;
        diff_window_size = 0.8;
        on_new_file_reject = "close_window";
        preview_context = 5;
        wrap_lines = false;
      };
    };
  };

  # The `claude` CLI comes from the user's environment, not a second copy
  # bundled into the editor
  dependencies.claude-code.enable = false;
}
