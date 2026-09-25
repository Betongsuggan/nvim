# Helpers shared by modules (as the `utils` module argument).
{
  # A Lua function body as a keymap action or callback
  lua = body: { __raw = "function() ${body} end"; };

  # An Ex command as a keymap action
  cmd = command: "<cmd>${command}<cr>";

  # Floating terminal geometry, shared by the snacks terminal and claudecode.
  # Non-zero scrolloff desyncs the drawn cursor row from the terminal grid
  # row until a resize forces a re-render, so both zero it (overriding the
  # global scrolloff = 8).
  floatTerminalWin = {
    position = "float";
    width = 0.9;
    height = 0.9;
    wo = {
      scrolloff = 0;
      sidescrolloff = 0;
    };
  };
}
