# Shared values used by more than one module.
{
  # Floating terminal window geometry, shared by the snacks terminal and
  # claudecode's snacks_win_opts. Non-zero scrolloff desyncs the drawn
  # cursor row from the terminal grid row until a resize forces a
  # re-render, so both zero it (overriding the global scrolloff = 8).
  floatTerminalWin = {
    position = "float";
    width = 0.9;
    height = 0.9;
    border = "rounded";
    wo = {
      scrolloff = 0;
      sidescrolloff = 0;
    };
  };
}
