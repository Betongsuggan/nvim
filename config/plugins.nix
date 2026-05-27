{ pkgs, ... }:
let
  theme = import ./theme.nix;

  lsp = import ./plugins/coding/lsp.nix { };
  completion = import ./plugins/coding/completion.nix { };
  treesitter = import ./plugins/coding/treesitter.nix { };

  editing = import ./plugins/editor/editing.nix { };
  navigation = import ./plugins/editor/navigation.nix { };
  extras = import ./plugins/editor/extras.nix { inherit pkgs; };

  statusline = import ./plugins/ui/statusline.nix { };
  whichKey = import ./plugins/ui/which-key.nix { };
  icons = import ./plugins/ui/icons.nix { inherit pkgs; };

  gitsigns = import ./plugins/git/gitsigns.nix { };

  trouble = import ./plugins/diagnostics/trouble.nix { };

  neotest = import ./plugins/testing/neotest.nix { };

  markdown = import ./plugins/tools/markdown.nix { inherit pkgs; };

  # snacks.nvim — picker/explorer/terminal/notifier/rename/bufdelete replace
  # telescope, neo-tree, toggleterm, and a pile of custom Lua. `terminal` and
  # `win` were already on for claudecode.nvim; everything else is now real.
  snacks = {
    plugins = {
      snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          dashboard.enabled = false;
          indent = {
            enabled = true;
            indent = { enabled = false; };  # no full-height indent guide lines
            scope = { enabled = true; };    # keep the scope highlight at the cursor
          };
          input.enabled = true;
          notifier = {
            enabled = true;
            timeout = 3000;
          };
          picker = {
            enabled = true;
            ui_select = true;
            layout = { preset = "default"; };
          };
          quickfile.enabled = true;
          scope.enabled = false;
          scroll.enabled = false;
          statuscolumn = {
            enabled = true;
            left = [ "mark" "sign" ];
            right = [ "fold" "git" ];
            git = { patterns = [ "GitSign" "MiniDiffSign" ]; };
          };
          words.enabled = true;
          terminal = {
            enabled = true;
            win = {
              position = "float";
              width = 0.9;
              height = 0.9;
              border = "rounded";
            };
          };
          win.enabled = true;
        };
      };
    };
  };
in {
  plugins = lsp.plugins // completion.plugins // treesitter.plugins
    // editing.plugins // navigation.plugins // extras.plugins
    // statusline.plugins // whichKey.plugins // (icons.plugins or { })
    // gitsigns.plugins // trouble.plugins // neotest.plugins
    // markdown.plugins // snacks.plugins;

  keymaps = (editing.keymaps or [ ]) ++ (neotest.keymaps or [ ])
    ++ (markdown.keymaps or [ ]) ++ (extras.keymaps or [ ]);

  autoCmd = (editing.autoCmd or [ ]);

  extraConfigLua = builtins.concatStringsSep "\n" [
    (neotest.extraConfigLua or "")
    (icons.extraConfigLua or "")
    (markdown.extraConfigLua or "")
    (extras.extraConfigLua or "")
  ];

  extraPlugins = with pkgs.vimPlugins;
    [ neotest-go neotest-plenary ]
    ++ (icons.extraPlugins or [ ])
    ++ (markdown.extraPlugins or [ ])
    ++ (extras.extraPlugins or [ ]);

  extraPackages = with pkgs; [ go delve ];
}
