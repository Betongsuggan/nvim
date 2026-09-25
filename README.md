# nvim

Nix flake for my Neovim setup, built on [nixvim](https://github.com/nix-community/nixvim):
a keyboard-driven IDE (LSP, completion, tests, debugging, git) that starts in
about 35 ms.

## Usage

```sh
nix run .            # core: Nix, Lua, Markdown, bash/JSON/YAML/TOML
nix run .#full       # every language
nix develop          # devShell: the editor + flake tooling (nixd, statix, deadnix, stylua)
nix fmt              # treefmt: nixfmt (width 80) + stylua + deadnix
nix flake check      # formatting + startup smoke tests (core and full)
```

With [direnv](https://direnv.net/), `direnv allow` loads the devShell automatically (`.envrc`).

### Choosing languages and colors

The package is built from options (`config/options.nix`); pick them with
`.extend`, so a machine only downloads what it uses:

```nix
inputs.nvim.packages.${system}.default.extend {
  languages = {
    go.enable = true;          # gopls, golines/gofumpt, delve, neotest-golang
    rust.enable = true;        # rustaceanvim, crates.nvim, lldb-dap
    typescript.enable = true;  # vtsls, neotest-jest
    kotlin.enable = true;      # kotlin-lsp, ktfmt, neotest-gradle (x86_64)
    lua.enable = true;         # lua_ls (Lua is always formatted/highlighted)
    nix.server = "nixd";       # or "nil" (~600 MiB smaller, no evaluation)
    nix.nixd.options.nixos = ''(builtins.getFlake "/path/to/flake").nixosConfigurations.host.options'';
  };
  theme.base16 = { base00 = "#1e1e2e"; /* … base0F */ };  # e.g. stylix colors; default catppuccin
}
```

`nixvimModules.default` exposes the same configuration as a nixvim module.

No compilers or build tools are bundled: `go`, `cargo`/`clippy`/`rustfmt`,
`node`, `git` and so on come from the project's devShell (or `PATH`), so the
editor uses the project's toolchain. nixpkgs tracks a NixOS release
(`nixos-26.05`, with nixvim's matching branch), so a NixOS flake on that
release can make this input follow its nixpkgs.

## Layout

```
flake.nix               packages (default = core, full), nixvimModules, checks
config/
  default.nix           entry: imports, startup performance, editor-wide packages
  options.nix           the flake's options (languages.*, theme.base16)
  core.nix              editor options, diagnostics, clipboard, autocommands
  keymaps.nix           EVERY keymap (global and buffer-local) + which-key groups
  languages.nix         EVERY language: server, formatter, grammars, tests, debugger
  languages/<lang>.nix  what doesn't fit the registry (rustaceanvim, kotlin jar://)
  icons.nix             every icon the config sets (glyphs as codepoints)
  theme.nix             base16 palette or catppuccin
  lib.nix               helpers (lua, cmd, floatTerminalWin), the `utils` arg
  plugins.nix           plugin module imports, lazy loading (lz-n)
  plugins/<area>/*.nix  language-independent plugin setup
  packages/kotlin-lsp.nix   JetBrains kotlin-lsp derivation (see below)
```

Adding a language is one entry in `languages.nix` (plus an option in
`options.nix`); adding a key is one line in `keymaps.nix`. Nerd Font glyphs go
in `icons.nix` as codepoints (`glyph "f057"`), never as literal characters,
which some editors silently drop.

## Keymaps

Leader is space; which-key shows the groups: `f` find, `l` LSP, `c` code,
`x` lists, `g` git, `t` test, `d` debug, `a` AI (Claude), `b` buffer,
`w` window, `q` session, `m` markdown, and in their buffers `r` Rust and
`C` crates. `<leader>fk` searches all keymaps. A build-time check rejects a
key mapped twice in the same scope.

## Startup

`luaLoader`, byte-compiled Lua and a single combined plugin directory, with
lazy loading for what isn't needed at startup (neotest, claudecode, crates,
diffview, grug-far, render-markdown, conform). Idle wake-ups are kept low by
slowing the timers of lualine, snacks and which-key (see their modules).

## Kotlin LSP

`config/packages/kotlin-lsp.nix` repacks JetBrains' official kotlin-lsp from
the VS Code Marketplace VSIX (x86_64-linux only). JetBrains EAP builds carry a
~30-day expiry, so bump `extensionVersion` + hash when the server starts
refusing to start. Goto-definition into dependency JARs is handled by the
`jar://` reader in `config/languages/kotlin.nix` (needs `unzip`, bundled with
Kotlin).

## Updating

```sh
nix flake update && nix flake check
```

On a new NixOS release, move `nixpkgs` and `nixvim` to the new `nixos-YY.MM`
branches together. The smoke checks start the editor on a file of every kind
for both builds and fail on any error, which catches most breakage from bumps.
Build-time patches (which-key, neotest) use `--replace-fail`, so a changed
upstream line fails the build instead of silently not applying.
