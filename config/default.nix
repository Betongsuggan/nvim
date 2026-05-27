{ pkgs, claudecode-nvim, ... }:
let theme = import ./theme.nix;
in {
  imports = [ ./options.nix ./plugins.nix ./keymaps.nix ];

  # Core nixvim configuration
  viAlias = true;
  vimAlias = true;

  # Colorscheme from theme
  colorschemes.${theme.name} = theme.colorscheme;

  # Include modular Lua files
  extraFiles = {
    "lua/config/init.lua" = {
      text = builtins.readFile ../lua/config/init.lua;
    };
    "lua/config/keymaps.lua" = {
      text = builtins.readFile ../lua/config/keymaps.lua;
    };
    "lua/config/rust.lua" = {
      text = builtins.readFile ../lua/config/rust.lua;
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
    nodejs_22 # Node.js runtime for TypeScript/JavaScript debugging
    lldb # LLVM debugger for Rust and C/C++
    # Formatters
    stylua # Lua formatter
    nixfmt # Nix formatter
    prettierd # TypeScript/JavaScript formatter
    eslint_d # TypeScript/JavaScript linter
    # Rust tooling
    rust-analyzer # Rust language server
    rustfmt # Rust formatter
    clippy # Rust linter
    cargo # Rust package manager
    rustc # Rust compiler

    gcc
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    # Popular colorschemes
    gruvbox-nvim
    tokyonight-nvim
    nord-nvim
    onedark-nvim
    nightfox-nvim
    dracula-nvim
    kanagawa-nvim
    rose-pine

    # Testing and debugging plugins
    neotest-golang
    neotest-plenary
    neotest-jest

    # Rust plugins
    rustaceanvim
    crates-nvim

    # Claude Code integration
    (pkgs.vimUtils.buildVimPlugin {
      name = "claudecode-nvim";
      src = claudecode-nvim;
    })
  ];

  # Initialize all Lua modules
  extraConfigLua = ''
    -- Core config (LSP handlers, diagnostics, folds, file-change autocmds).
    require('config').setup()

    -- Keymap helper functions (close_other_buffers, project run/build/test).
    require('config.keymaps').setup()

    -- Rust-specific config (rustaceanvim + crates.nvim).
    require('config.rust').setup()

    -- Setup claudecode.nvim
    require('claudecode').setup({
      terminal_cmd = nil,
      auto_start = true,
      log_level = "info",

      terminal = {
        provider = "snacks",
        auto_close = false,
        snacks_win_opts = {
          position = "float",
          width = 0.9,
          height = 0.9,
          border = "rounded",
        },
      },

      diff_opts = {
        auto_close_on_accept = true,
        auto_close_on_reject = true,
        vertical_split = false,
        close_other_windows = false,
        focus_diff_window = true,
        diff_window_size = 0.8,
        on_new_file_reject = "close_window",
        preview_context = 5,
        wrap_lines = false
      }
    })
  '';
}
