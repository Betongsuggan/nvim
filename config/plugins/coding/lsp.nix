# LSP server configurations
{ pkgs, icons, ... }:
{
  # LSP progress ($/progress, e.g. kotlin-lsp's ~10 s Gradle import) as one
  # updating snacks notification with a spinner
  autoCmd = [
    {
      desc = "Show LSP progress";
      event = "LspProgress";
      callback.__raw = ''
        function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
            id = "lsp_progress",
            title = "LSP",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and "${icons.glyph "f00c"} "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end
      '';
    }
  ];

  plugins.lsp = {
    enable = true;
    servers = {
      gopls = {
        enable = true;
        settings = {
          gopls = {
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
              gc_details = false;
              generate = true;
              regenerate_cgo = false;
              run_govulncheck = false;
              test = true;
              tidy = true;
              upgrade_dependency = false;
              vendor = false;
            };
            semanticTokens = false; # Treesitter handles highlighting
            symbolMatcher = "FastFuzzy";
            symbolStyle = "Dynamic";
          };
        };
      };

      vtsls = {
        enable = true;
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = {
                enabled = "all";
              };
              parameterTypes = {
                enabled = true;
              };
              variableTypes = {
                enabled = true;
              };
              propertyDeclarationTypes = {
                enabled = true;
              };
              functionLikeReturnTypes = {
                enabled = true;
              };
              enumMemberValues = {
                enabled = true;
              };
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
            updateImportsOnFileMove = {
              enabled = "always";
            };
            workspaceSymbols = {
              scope = "allOpenProjects";
            };
          };
          javascript = {
            inlayHints = {
              parameterNames = {
                enabled = "all";
              };
              parameterTypes = {
                enabled = true;
              };
              variableTypes = {
                enabled = true;
              };
              propertyDeclarationTypes = {
                enabled = true;
              };
              functionLikeReturnTypes = {
                enabled = true;
              };
              enumMemberValues = {
                enabled = true;
              };
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
            updateImportsOnFileMove = {
              enabled = "always";
            };
          };
          vtsls = {
            autoUseWorkspaceTsdk = true;
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true;
              };
            };
          };
          completions = {
            completeFunctionCalls = true;
          };
        };
      };

      nixd = {
        enable = true;
        settings = {
          nixd = {
            nixpkgs = {
              # The flake registry's nixpkgs (the system's, on NixOS with
              # flakes). Interpolating this flake's pkgs.path instead would
              # put a whole nixpkgs source tree into the editor's closure.
              expr = "import (builtins.getFlake \"nixpkgs\") { }";
            };
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };

      kotlin_lsp = rec {
        # Our derivation repacks JetBrains' x86_64-linux VSIX; other systems
        # get no kotlin-lsp rather than a broken build.
        enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        # Our own derivation — nixpkgs has no kotlin-lsp package. Newer
        # JetBrains releases bundle their own JRE.
        package =
          if enable then pkgs.callPackage ../../packages/kotlin-lsp.nix { } else null;
        cmd = [
          "kotlin-lsp"
          "--stdio"
        ];
        filetypes = [ "kotlin" ];
        rootMarkers = [
          "settings.gradle.kts"
          "settings.gradle"
          "build.gradle.kts"
          "build.gradle"
          "pom.xml"
          "mvnw"
          ".git"
        ];
      };

      # Rust LSP is handled by rustaceanvim plugin
      rust_analyzer = {
        enable = false;
      };
    };
  };
}
