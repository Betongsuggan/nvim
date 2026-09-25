# Which-Key keymap discovery configuration
{ pkgs, ... }:
{
  plugins.which-key = {
    enable = true;
    # which-key polls the mode every 50 ms (hardcoded) as a fallback for
    # ModeChanged not firing after `:norm` in autocmds (folke/which-key.nvim#787),
    # the single biggest idle wake-up source left (~20/s). ModeChanged still
    # drives it; the fallback only has to catch the rare miss.
    package = pkgs.vimPlugins.which-key-nvim.overrideAttrs {
      postPatch = ''
        substituteInPlace lua/which-key/state.lua \
          --replace-fail "timer:start(0, 50, function()" "timer:start(0, 500, function()"
      '';
    };
    settings = {
      delay = 500;
      expand = 1;
      notify = false;
      preset = "modern";
      replace = {
        desc = [
          [
            "<space>"
            " "
          ]
          [
            "<leader>"
            " "
          ]
          [
            "<[cC][rR]>"
            " "
          ]
          [
            "<[tT][aA][bB]>"
            " "
          ]
          [
            "<[bB][sS]>"
            " "
          ]
        ];
      };
      # Groups: keymaps.nix
      win = {
        padding = [
          1
          2
        ];
      };
    };
  };
}
