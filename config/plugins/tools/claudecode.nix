# claudecode.nvim — Claude Code integration. Not wrapped by nixvim, so the
# plugin is built from the flake input and configured in Lua.
{
  pkgs,
  lib,
  claudecode-nvim,
  ...
}:
let
  shared = import ../../lib.nix;
in
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "claudecode-nvim";
      src = claudecode-nvim;
    })
  ];

  extraConfigLua = ''
    -- Setup claudecode.nvim
    require('claudecode').setup({
      terminal_cmd = nil,
      auto_start = true,
      log_level = "info",

      terminal = {
        provider = "snacks",
        auto_close = false,
        snacks_win_opts = ${lib.nixvim.toLuaObject shared.floatTerminalWin},
      },

      diff_opts = {
        auto_close_on_accept = true,
        auto_close_on_reject = true,
        vertical_split = false,
        close_other_windows = false,
        focus_diff_window = true,
        diff_window_size = 0.8,
        on_new_file_reject = "close_window",
        preview_context = 5,
        wrap_lines = false
      }
    })
  '';
}
