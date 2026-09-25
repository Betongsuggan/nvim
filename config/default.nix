{ pkgs, ... }:
let
  theme = import ./theme.nix;
in
{
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  # Core nixvim configuration
  viAlias = true;
  vimAlias = true;

  # Startup speed: Neovim's module loader caches resolved Lua modules, and
  # everything (init.lua, plugins, runtime, lua libs) ships as bytecode.
  luaLoader.enable = true;
  performance = {
    byteCompileLua = {
      enable = true;
      plugins = true;
      nvimRuntime = true;
      luaLib = true;
    };
    # One runtimepath entry for all plugins instead of one per plugin. The
    # standalone ones ship files that collide with another plugin's.
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "snacks.nvim" # queries/markdown/injections.scm (treesitter queries)
        "blink.cmp" # doc/recipes.md (conform)
        "nord.nvim" # lua/lualine/themes/nord.lua (lualine)
        "onedark.nvim" # lua/lualine/themes/onedark.lua (lualine)
      ];
    };
  };

  # No remote-plugin hosts: no plugin here is written against them, and each
  # adds its interpreter to the closure
  withPython3 = false;
  withRuby = false;
  withPerl = false;
  withNodeJs = false;

  # gopls runs `go` from PATH like the other toolchains, rather than having
  # nixvim bundle a Go
  dependencies.go.enable = false;

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
    "lua/config/floating_diff.lua" = {
      text = builtins.readFile ../lua/config/floating_diff.lua;
    };
  };

  # Language servers, formatters and debuggers the config calls. Compilers
  # and build tools (go, cargo/clippy, node, gcc, ...) are not bundled: they
  # come from the project's devShell (direnv) or the user's PATH, so the
  # editor uses the same toolchain as the project.
  extraPackages = with pkgs; [
    ripgrep # Required by Snacks.picker.grep
    unzip # Required by the kotlin-lsp jar:// reader (lua/config/init.lua)
    # Debuggers
    delve # Go
    lldb # Rust and C/C++ (lldb-dap)
    # Formatters
    stylua # Lua formatter
    nixfmt # Nix formatter
    golines # Go line-length formatter (conform)
    gofumpt # Go formatter, golines base formatter (conform)
    # Rust language server (rustaceanvim); rustfmt and clippy belong to the
    # project's toolchain (rustfmt links against rustc, ~1 GB)
    rust-analyzer
    # Kotlin formatter (Google), on the regular JDK instead of its own
    # headless one: the same JDK development environments already install
    (ktfmt.override { jre_headless = jdk; })
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

  ];

  # Initialize all Lua modules
  extraConfigLua = ''
    -- Core config (LSP handlers, diagnostics, folds, file-change autocmds).
    require('config').setup()
  '';
}
