# nvim

Nix flake for my Neovim setup, built on [nixvim](https://github.com/nix-community/nixvim).

## Usage

```sh
nix run .            # launch directly
nix build .#nvim     # build; binary at ./result/bin/nvim
nix develop          # devShell: the editor + flake tooling (nixd, statix, deadnix, stylua)
nix fmt              # treefmt: nixfmt (width 80) + stylua + deadnix
nix flake check      # build + headless startup smoke test + formatting
```

With [direnv](https://direnv.net/), `direnv allow` loads the devShell automatically (`.envrc`).

The package bundles language servers, formatters and debuggers, but no
compilers or build tools: `go`, `cargo`/`clippy`/`rustfmt`, `node` and so on
come from the project's own devShell (or `PATH`), so the editor always uses
the project's toolchain. nixpkgs tracks a NixOS release (`nixos-26.05`, with
nixvim's matching branch) so a NixOS flake on that release can make this
input follow its nixpkgs.

## Layout

```
flake.nix                    inputs, packages, devShell, formatter, checks
config/
  default.nix                entry module: extraFiles, extraPackages, colorscheme
  options.nix                vim options and globals
  keymaps.nix                central keymap list (uses lib.nix helpers)
  theme.nix                  default colorscheme (runtime switching = themery)
  lib.nix                    shared helpers: nmap/nmapSilent/nmapLua/luaFn,
                             floatTerminalWin
  plugins.nix                imports list for all plugin modules
  plugins/<area>/<name>.nix  one nixvim module per plugin
  packages/kotlin-lsp.nix    JetBrains kotlin-lsp derivation (see below)
lua/config/                  Lua shipped verbatim via extraFiles:
  init.lua                   LSP handlers, diagnostics, folds, kotlin jar:// reader
  keymaps.lua                helper fns called from keymaps.nix via require()
  floating_diff.lua          floating side-by-side git diff viewer
```

Plugin modules are ordinary nixvim modules — add `plugins`, `keymaps`,
`autoCmd`, `extraPackages`, etc. in any file under `config/plugins/` and the
module system merges them. Register new files in `config/plugins.nix`.

## Keymaps

Leader is space. which-key (`<space>` then wait) shows the groups:
`f` find, `c` code, `C` crates, `b` buffer, `g` git, `w` windows, `t` testing,
`d` debug, `l` LSP, `x` diagnostics, `r` rust (buffer-local), `m` markdown,
`p` project, `q` quit/session, `T` theme. `<leader>fk` opens a keymap picker.

## Kotlin LSP

`config/packages/kotlin-lsp.nix` repacks JetBrains' official kotlin-lsp from
the VS Code Marketplace VSIX (x86_64-linux only — the flake still evaluates on
other systems, just without kotlin-lsp). Note: JetBrains EAP builds carry a
~30-day expiry, so bump `extensionVersion` + hash when the server starts
refusing to start. Goto-definition into dependency JARs is handled by the
`jar://` reader in `lua/config/init.lua` (needs `unzip`, shipped via
extraPackages).

## Updating

```sh
nix flake update && nix flake check
```

On a new NixOS release, move `nixpkgs` and `nixvim` to the new
`nixos-YY.MM` branches together.

The smoke check executes the full generated `init.lua`, which catches most
plugin breakage from bumps before it reaches an interactive session.
