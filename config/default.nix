{ pkgs, ... }:
{
  imports = [
    ./options.nix
    ./core.nix
    ./theme.nix
    ./plugins.nix
    ./keymaps.nix
    ./languages/kotlin.nix
  ];

  # Shared with every module as arguments
  _module.args = {
    icons = import ./icons.nix;
    utils = import ./lib.nix;
  };

  viAlias = true;
  vimAlias = true;

  # No remote-plugin hosts: no plugin here is written against them, and each
  # adds its interpreter to the closure
  withPython3 = false;
  withRuby = false;
  withPerl = false;
  withNodeJs = false;

  # gopls runs `go` from PATH like the other toolchains, rather than having
  # nixvim bundle a Go
  dependencies.go.enable = false;

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
      ];
    };
  };

  # Language servers, formatters and debuggers the config calls. Compilers
  # and build tools (go, cargo/clippy, node, gcc, ...) are not bundled: they
  # come from the project's devShell (direnv) or the user's PATH, so the
  # editor uses the same toolchain as the project.
  extraPackages = with pkgs; [
    ripgrep # Required by Snacks.picker.grep
    unzip # Required by the kotlin-lsp jar:// reader (languages/kotlin.nix)
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
}
