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
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
        }
        {
          __unkeyed-1 = "<leader>p";
          group = "Project";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>gc";
          group = "Conflict";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "Windows";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "Testing";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "Debug";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "Trouble";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "Rust";
        }
        {
          __unkeyed-1 = "<leader>C";
          group = "Crates";
        }
        {
          __unkeyed-1 = "<leader>m";
          group = "Markdown";
        }
        {
          __unkeyed-1 = "<leader>q";
          group = "Quit/Session";
        }
        {
          __unkeyed-1 = "<C-a>";
          desc = "Toggle Claude";
        }
        {
          __unkeyed-1 = "<C-b>";
          desc = "Add current buffer to Claude";
        }
        {
          __unkeyed-1 = "<C-s>";
          desc = "Send selection to Claude";
          mode = "v";
        }
        {
          __unkeyed-1 = "<C-y>";
          desc = "Accept diff";
        }
        {
          __unkeyed-1 = "<C-n>";
          desc = "Deny diff";
        }
        {
          __unkeyed-1 = "<C-a>";
          desc = "Toggle Claude from terminal";
          mode = "t";
        }
      ];
      win = {
        border = "rounded";
        padding = [
          1
          2
        ];
      };
    };
  };
}
