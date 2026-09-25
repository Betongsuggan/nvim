# Every language in one registry: its language server, formatter, grammars,
# test adapter, debugger and tools, enabled by `languages.<name>.enable`
# (options.nix). Nix, Lua (formatting), Markdown and the data formats are
# always on. The generic modules (plugins/) hold only language-independent
# behavior; language servers are all defined here, except rust-analyzer,
# which rustaceanvim runs (languages/rust.nix).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.languages;
  grammars = config.plugins.treesitter.package.builtGrammars;

  # One settings set for both TypeScript and JavaScript
  tsSettings = {
    inlayHints = {
      parameterNames.enabled = "all";
      parameterTypes.enabled = true;
      variableTypes.enabled = true;
      propertyDeclarationTypes.enabled = true;
      functionLikeReturnTypes.enabled = true;
      enumMemberValues.enabled = true;
    };
    suggest = {
      autoImports = true;
      completeFunctionCalls = true;
      includeCompletionsForModuleExports = true;
      includeCompletionsForImportStatements = true;
    };
    preferences = {
      importModuleSpecifier = "shortest";
      includePackageJsonAutoImports = "on";
    };
    updateImportsOnFileMove.enabled = "always";
  };

  registry = {
    nix = {
      enable = true;
      config = {
        plugins.treesitter.grammarPackages = [ grammars.nix ];
        plugins.conform-nvim.settings = {
          formatters_by_ft.nix = [ "nixfmt" ];
          formatters.nixfmt.prepend_args = [
            "--width"
            "80"
          ];
        };
        extraPackages = [ pkgs.nixfmt ];

        lsp.servers.nixd = lib.mkIf (cfg.nix.server == "nixd") {
          enable = true;
          config.settings.nixd = {
            # The flake registry's nixpkgs (the system's, on NixOS with
            # flakes); this flake's own would put a nixpkgs source tree into
            # the closure
            nixpkgs.expr = ''import (builtins.getFlake "nixpkgs") { }'';
            formatting.command = [ "nixfmt" ];
            options = lib.mapAttrs (_: expr: { inherit expr; }) cfg.nix.nixd.options;
          };
        };
        lsp.servers.nil_ls = lib.mkIf (cfg.nix.server == "nil") {
          enable = true;
          config.settings.nil.formatting.command = [ "nixfmt" ];
        };
      };
    };

    lua = {
      enable = true;
      config = {
        plugins.treesitter.grammarPackages = [ grammars.lua ];
        plugins.conform-nvim.settings = {
          formatters_by_ft.lua = [ "stylua" ];
          formatters.stylua.prepend_args = [
            "--indent-type"
            "Spaces"
            "--indent-width"
            "2"
          ];
        };
        extraPackages = [ pkgs.stylua ];
        lsp.servers.lua_ls.enable = cfg.lua.enable;
      };
    };

    markdown = {
      enable = true;
      config = {
        plugins.treesitter.grammarPackages = with grammars; [
          markdown
          markdown_inline
        ];
        # Trailing spaces are line breaks in markdown
        plugins.conform-nvim.settings.formatters_by_ft.markdown = [ ];
        # Headings, code blocks, checkboxes and tables rendered in place
        plugins.render-markdown = {
          enable = true;
          lazyLoad.settings.ft = "markdown";
          settings.code.border = "thin";
        };
      };
    };

    # Syntax only
    data = {
      enable = true;
      config.plugins.treesitter.grammarPackages = with grammars; [
        bash
        json
        yaml
        toml
      ];
    };

    go = {
      inherit (cfg.go) enable;
      config = {
        plugins.treesitter.grammarPackages = with grammars; [
          go
          gomod
          gosum
        ];
        lsp.servers.gopls = {
          enable = true;
          config.settings.gopls = {
            analyses = {
              unusedparams = true;
              unusedvariable = true;
              unusedwrite = true;
              unreachable = true;
            };
            staticcheck = true;
            gofumpt = true;
            matcher = "Fuzzy";
            completeUnimported = true;
            deepCompletion = true;
            usePlaceholders = true;
            completionDocumentation = true;
            hoverKind = "FullDocumentation";
            linkTarget = "pkg.go.dev";
            codelenses = {
              generate = true;
              test = true;
              tidy = true;
            };
            semanticTokens = false; # treesitter highlights
            symbolMatcher = "FastFuzzy";
            symbolStyle = "Dynamic";
          };
        };
        # golines runs gofumpt itself (--base-formatter)
        plugins.conform-nvim.settings = {
          formatters_by_ft.go = [ "golines" ];
          formatters.golines.prepend_args = [
            "--max-len=120"
            "--base-formatter=gofumpt"
          ];
        };
        plugins.neotest = {
          enable = true;
          adapters.golang = {
            enable = true;
            settings = {
              go_test_args = [
                "-v"
                "-count=1"
              ];
              dap_go_enabled = true;
            };
          };
        };
        # delve, also the strategy neotest-golang debugs with
        plugins.dap.enable = true;
        plugins.dap-go.enable = true;
        extraPackages = with pkgs; [
          golines
          gofumpt
          delve
        ];
      };
    };

    rust = {
      inherit (cfg.rust) enable;
      # rustaceanvim, crates.nvim: languages/rust.nix
      config = {
        plugins.treesitter.grammarPackages = [
          grammars.rust
          grammars.ron
        ];
        # rust-analyzer formats (rustfmt from the project's toolchain)
        plugins.conform-nvim.settings.formatters_by_ft.rust = [ ];
        plugins.dap.enable = true;
        extraPackages = with pkgs; [
          rust-analyzer
          lldb # lldb-dap, found by rustaceanvim's debuggables
        ];
      };
    };

    typescript = {
      inherit (cfg.typescript) enable;
      config = {
        plugins.treesitter.grammarPackages = with grammars; [
          typescript
          tsx
          javascript
        ];
        lsp.servers.vtsls = {
          enable = true;
          config.settings = {
            typescript = tsSettings // {
              workspaceSymbols.scope = "allOpenProjects";
            };
            javascript = tsSettings;
            vtsls = {
              autoUseWorkspaceTsdk = true;
              experimental.completion.enableServerSideFuzzyMatch = true;
            };
          };
        };
        # vtsls formats
        plugins.conform-nvim.settings.formatters_by_ft = lib.genAttrs [
          "typescript"
          "typescriptreact"
          "javascript"
          "javascriptreact"
        ] (_: [ ]);
        plugins.neotest = {
          enable = true;
          adapters.jest = {
            enable = true;
            settings = {
              jestCommand = "npx jest --";
              # A jest.config.* when the project has one; otherwise jest
              # reads its config from package.json
              jestConfigFile.__raw = ''
                function()
                  for _, name in ipairs({ "jest.config.ts", "jest.config.js", "jest.config.mjs" }) do
                    local p = vim.fn.getcwd() .. "/" .. name
                    if vim.fn.filereadable(p) == 1 then return p end
                  end
                end
              '';
              env.CI = "true";
              cwd.__raw = "function() return vim.fn.getcwd() end";
            };
          };
        };
      };
    };

    kotlin = {
      # The kotlin-lsp derivation repacks JetBrains' x86_64-linux build
      enable = cfg.kotlin.enable && pkgs.stdenv.hostPlatform.system == "x86_64-linux";
      # jar:// sources and the Gradle test adapter's fixes: languages/kotlin.nix
      config = {
        # java: sources of the JDK and dependencies goto-definition opens
        plugins.treesitter.grammarPackages = with grammars; [
          kotlin
          java
          groovy
        ];
        lsp.servers.kotlin_lsp = {
          enable = true;
          package = pkgs.callPackage ./packages/kotlin-lsp.nix { };
          config = {
            cmd = [
              "kotlin-lsp"
              "--stdio"
            ];
            filetypes = [ "kotlin" ];
            root_markers = [
              "settings.gradle.kts"
              "settings.gradle"
              "build.gradle.kts"
              "build.gradle"
              "pom.xml"
              "mvnw"
              ".git"
            ];
          };
        };
        plugins.conform-nvim.settings.formatters_by_ft.kotlin = [ "ktfmt" ];
        plugins.neotest = {
          enable = true;
          adapters.gradle.enable = true;
        };
        extraPackages = with pkgs; [
          # On the regular JDK instead of its own headless one: the JDK
          # Kotlin development environments already install
          (ktfmt.override { jre_headless = jdk; })
          unzip # the jar:// reader
        ];
      };
    };
  };
in
{
  imports = [
    ./languages/rust.nix
    ./languages/kotlin.nix
  ];

  config = lib.mkMerge (
    lib.mapAttrsToList (_: l: lib.mkIf l.enable l.config) registry
  );
}
