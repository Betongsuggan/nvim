{ pkgs, claudecode-nvim, ... }:
let theme = import ./theme.nix;
in {
  imports = [ ./options.nix ./plugins.nix ./keymaps.nix ];

  # Core nixvim configuration
  viAlias = true;
  vimAlias = true;

  # Colorscheme from theme
  colorschemes.${theme.name} = theme.colorscheme;

  # Terminal plugin
  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        width = { __raw = "math.floor(vim.o.columns * 0.8)"; };
        height = { __raw = "math.floor(vim.o.lines * 0.8)"; };
      };
      shell = "bash";
    };
  };

  # Include modular Lua files
  extraFiles = {
    "lua/testing/adapter.lua" = {
      text = builtins.readFile ../lua/testing/adapter.lua;
    };
    "lua/testing/registry.lua" = {
      text = builtins.readFile ../lua/testing/registry.lua;
    };
    "lua/testing/runner.lua" = {
      text = builtins.readFile ../lua/testing/runner.lua;
    };
    "lua/testing/ui.lua" = { text = builtins.readFile ../lua/testing/ui.lua; };
    "lua/testing/telescope.lua" = {
      text = builtins.readFile ../lua/testing/telescope.lua;
    };
    "lua/testing/adapters/go.lua" = {
      text = builtins.readFile ../lua/testing/adapters/go.lua;
    };
    "lua/testing/adapters/typescript.lua" = {
      text = builtins.readFile ../lua/testing/adapters/typescript.lua;
    };
  };

  # Additional packages needed by plugins
  extraPackages = with pkgs; [
    ripgrep # Required by telescope live_grep
    # Nerd Fonts for proper icon display
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    # Debugging tools
    delve # Go debugger
    nodejs_20 # Node.js runtime for TypeScript/JavaScript debugging
    # Formatters
    stylua # Lua formatter
    nixfmt-classic # Nix formatter
    prettierd # TypeScript/JavaScript formatter
    eslint_d # TypeScript/JavaScript linter

    gcc
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    nvim-scrollbar

    # Popular colorschemes
    gruvbox-nvim # Gruvbox - retro groove colors
    tokyonight-nvim # Tokyo Night - modern dark theme
    nord-nvim # Nord - arctic, north-bluish theme
    onedark-nvim # OneDark - Atom's iconic One Dark theme
    nightfox-nvim # Nightfox - highly customizable theme
    dracula-nvim # Dracula - dark theme inspired by the famous color palette
    kanagawa-nvim # Kanagawa - inspired by the famous painting
    rose-pine # Rosé Pine - soho vibes theme

    # Testing and debugging plugins  
    neotest-go # Go test adapter for neotest
    neotest-plenary # Plenary test adapter
    neotest-jest # Jest test adapter for TypeScript/JavaScript

    # Claude Code integration
    (pkgs.vimUtils.buildVimPlugin {
      name = "claudecode-nvim";
      src = claudecode-nvim;
    })
  ];

  # Claude Code plugin configuration
  extraConfigLua = ''
    -- Setup claudecode.nvim
    require('claudecode').setup({
      terminal_cmd = nil, -- Auto-detect Claude CLI
      auto_start = true,
      log_level = "info",

      terminal = {
        provider = "native", -- Use native terminal for better session persistence
        auto_close = false,  -- Don't auto-close terminal to keep session alive
      },

      diff_opts = {
        auto_close_on_accept = true,
        auto_close_on_reject = true, -- Also close on reject for consistency
        vertical_split = false, -- Use horizontal split to give more width
        close_other_windows = false, -- Don't auto-close other windows
        focus_diff_window = true, -- Focus the diff window when opened
        diff_window_size = 0.8, -- Use 80% of screen for diff view
        on_new_file_reject = "close_window", -- Clean up rejected changes
        preview_context = 5, -- Show 5 lines of context around changes
        wrap_lines = false -- Don't wrap long lines in diff view
      }
    })
  '';

  # Configure nvim-scrollbar with theme colors and theme switching
  # Configuration moved to individual plugin files for better organization
  # - Theme configuration: config/plugins/themes.nix
  # - UI/scrollbar configuration: config/plugins/ui-visual.nix
  # - Test configuration: config/plugins/testing-debug.nix
}
