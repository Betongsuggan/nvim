# Shared values and helpers used by more than one module.
rec {
  # Wrap a Lua expression/statement in a zero-arg function for keymap actions.
  luaFn = body: {
    __raw = "function() ${body} end";
  };

  # Normal-mode keymap. `action` is a vim command string or a luaFn value.
  nmap = key: action: desc: {
    mode = "n";
    inherit key action;
    options = {
      inherit desc;
    };
  };

  # Same, with silent = true.
  nmapSilent = key: action: desc: {
    mode = "n";
    inherit key action;
    options = {
      inherit desc;
      silent = true;
    };
  };

  # Shorthand: silent normal-mode map running a Lua body.
  nmapLua =
    key: body: desc:
    nmapSilent key (luaFn body) desc;

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
