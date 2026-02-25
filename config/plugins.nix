{ pkgs, ... }:
let
  # Import theme configuration
  theme = import ./theme.nix;

  # Import plugin categories - new semantic structure
  # Coding
  lsp = import ./plugins/coding/lsp.nix { };
  completion = import ./plugins/coding/completion.nix { };
  treesitter = import ./plugins/coding/treesitter.nix { };

  # Editor
  editing = import ./plugins/editor/editing.nix { };
  navigation = import ./plugins/editor/navigation.nix { };

  # UI
  statusline = import ./plugins/ui/statusline.nix { inherit theme; };
  whichKey = import ./plugins/ui/which-key.nix { };
  icons = import ./plugins/ui/icons.nix { inherit pkgs; };

  # Git
  gitsigns = import ./plugins/git/gitsigns.nix { };

  # Diagnostics
  trouble = import ./plugins/diagnostics/trouble.nix { };

  # Testing
  neotest = import ./plugins/testing/neotest.nix { };

  # Tools
  telescope = import ./plugins/tools/telescope.nix { };
  terminal = import ./plugins/tools/terminal.nix { };
  markdown = import ./plugins/tools/markdown.nix { inherit pkgs; };

  # Snacks.nvim for floating windows (used by claudecode)
  # Only enable terminal/win features, disable others to avoid UI conflicts
  snacks = {
    plugins = {
      snacks = {
        enable = true;
        settings = {
          # Disable features that override other plugins
          bigfile.enabled = false;
          dashboard.enabled = false;
          indent.enabled = false;
          input.enabled = false;
          notifier.enabled = false;
          picker.enabled = false;
          quickfile.enabled = false;
          scope.enabled = false;
          scroll.enabled = false;
          statuscolumn.enabled = false;
          words.enabled = false;
          # Keep terminal and win enabled (needed for claudecode)
          terminal.enabled = true;
          win.enabled = true;
        };
      };
    };
  };
in {
  # Merge all plugin configurations
  plugins = lsp.plugins // completion.plugins // treesitter.plugins
    // editing.plugins // navigation.plugins // statusline.plugins
    // whichKey.plugins // (icons.plugins or { }) // gitsigns.plugins
    // trouble.plugins // neotest.plugins // telescope.plugins
    // terminal.plugins // markdown.plugins // snacks.plugins;

  # Merge keymaps from modules that define them
  keymaps = (editing.keymaps or [ ]) ++ (neotest.keymaps or [ ])
    ++ (markdown.keymaps or [ ]);

  # Merge autoCmd from modules
  autoCmd = (editing.autoCmd or [ ]);

  # Merge extraConfigLua from modules
  extraConfigLua = builtins.concatStringsSep "\n" [
    (neotest.extraConfigLua or "")
    (icons.extraConfigLua or "")
    (markdown.extraConfigLua or "")
  ];

  # Extra plugins not available as nixvim plugins
  extraPlugins = with pkgs.vimPlugins;
    [ neotest-go neotest-plenary nvim-scrollbar ]
    ++ (icons.extraPlugins or [ ])
    ++ (markdown.extraPlugins or [ ]);

  # Ensure Go tools are available
  extraPackages = with pkgs; [ go delve ];
}
