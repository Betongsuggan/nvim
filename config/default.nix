{ pkgs, ... }:
let theme = import ./theme.nix;
in {
  imports = [ ./options.nix ./plugins.nix ./keymaps.nix ];

  # Basic nixvim configuration
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
        width = 120;
        height = 30;
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
    # Formatters
    stylua # Lua formatter
    nixfmt-classic # Nix formatter
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

    # Claude Code integration
    (pkgs.vimUtils.buildVimPlugin {
      name = "claudecode-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "coder";
        repo = "claudecode.nvim";
        rev = "main";
        sha256 = "sha256-sOBY2y/buInf+SxLwz6uYlUouDULwebY/nmDlbFbGa8=";
      };
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
        vertical_split = true,
        on_new_file_reject = "keep_empty" -- Keep buffers instead of closing
      }
    })
  '';

  # Configure nvim-scrollbar with theme colors and theme switching
  # Configuration moved to individual plugin files for better organization
  # - Theme configuration: config/plugins/themes.nix
  # - UI/scrollbar configuration: config/plugins/ui-visual.nix
  # - Test configuration: config/plugins/testing-debug.nix
}
