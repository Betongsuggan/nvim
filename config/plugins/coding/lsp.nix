# LSP server configurations
{ pkgs, ... }:
{
  # Fidget surfaces $/progress notifications from LSP servers in the corner of
  # the screen — important for the JetBrains kotlin-lsp, which takes ~9 s on a
  # warm cache (and ~25 s cold) to finish Gradle re-validation and workspace
  # model load before completion/hover/goto-def respond. Leaves vim.notify
  # alone so snacks.notifier remains the toast renderer.
  plugins.fidget = {
    enable = true;
    settings = {
      progress = {
        display = {
          done_icon = "";
          progress_icon = {
            pattern = "dots";
            period = 1;
          };
        };
      };
      notification = {
        override_vim_notify = false;
      };
    };
  };

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
