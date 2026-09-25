{ pkgs, ... }:
{
  imports = [
    ./options.nix
    ./core.nix
    ./theme.nix
    ./plugins.nix
    ./keymaps.nix
    ./languages.nix
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

  # gopls runs `go`, and gitsigns/diffview run `git`, from PATH like the
  # other toolchains, rather than nixvim bundling them (git alone brings
  # python and perl, ~250 MiB)
  dependencies.go.enable = false;
  dependencies.git.enable = false;

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

  # Tools the editor itself calls; each language adds its own servers,
  # formatters and debuggers (languages.nix). Compilers and build tools are
  # never bundled: they come from the project's devShell (direnv) or PATH,
  # so the editor uses the project's toolchain.
  extraPackages = [
    pkgs.ripgrep # Snacks.picker.grep
  ];
}
