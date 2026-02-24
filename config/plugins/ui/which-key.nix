# Which-Key keymap discovery configuration
{ ... }: {
  plugins.which-key = {
    enable = true;
    settings = {
      delay = 500;
      expand = 1;
      notify = false;
      preset = "modern";
      replace = {
        desc = [
          [ "<space>" " " ]
          [ "<leader>" " " ]
          [ "<[cC][rR]>" " " ]
          [ "<[tT][aA][bB]>" " " ]
          [ "<[bB][sS]>" " " ]
        ];
      };
      spec = [
        { __unkeyed-1 = "<leader>f"; group = "Find"; icon = ">"; }
        { __unkeyed-1 = "<leader>c"; group = "Code"; icon = "#"; }
        { __unkeyed-1 = "<leader>p"; group = "Project"; icon = "@"; }
        { __unkeyed-1 = "<leader>b"; group = "Buffer"; icon = "B"; }
        { __unkeyed-1 = "<leader>g"; group = "Git"; icon = "G"; }
        { __unkeyed-1 = "<leader>w"; group = "Windows"; icon = "W"; }
        { __unkeyed-1 = "<leader>t"; group = "Testing"; icon = "T"; }
        { __unkeyed-1 = "<leader>T"; group = "Theme"; icon = "*"; }
        { __unkeyed-1 = "<leader>l"; group = "LSP"; icon = "L"; }
        { __unkeyed-1 = "<leader>d"; group = "Diagnostics"; icon = "D"; }
        { __unkeyed-1 = "<leader>r"; group = "Rust"; icon = "R"; }
        { __unkeyed-1 = "<C-a>"; desc = "Toggle Claude"; icon = "C"; }
        { __unkeyed-1 = "<C-b>"; desc = "Add current buffer to Claude"; icon = "+"; }
        { __unkeyed-1 = "<C-s>"; desc = "Send selection to Claude"; icon = ">"; mode = "v"; }
        { __unkeyed-1 = "<C-y>"; desc = "Accept diff"; icon = "Y"; }
        { __unkeyed-1 = "<C-n>"; desc = "Deny diff"; icon = "N"; }
        { __unkeyed-1 = "<C-a>"; desc = "Toggle Claude from terminal"; icon = "C"; mode = "t"; }
      ];
      win = {
        border = "rounded";
        padding = [ 1 2 ];
      };
    };
  };
}
