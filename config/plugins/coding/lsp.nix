# LSP server configurations
{ ... }: {
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
              parameterNames = { enabled = "all"; };
              parameterTypes = { enabled = true; };
              variableTypes = { enabled = true; };
              propertyDeclarationTypes = { enabled = true; };
              functionLikeReturnTypes = { enabled = true; };
              enumMemberValues = { enabled = true; };
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
            updateImportsOnFileMove = { enabled = "always"; };
            workspaceSymbols = { scope = "allOpenProjects"; };
          };
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all"; };
              parameterTypes = { enabled = true; };
              variableTypes = { enabled = true; };
              propertyDeclarationTypes = { enabled = true; };
              functionLikeReturnTypes = { enabled = true; };
              enumMemberValues = { enabled = true; };
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
            updateImportsOnFileMove = { enabled = "always"; };
          };
          vtsls = {
            autoUseWorkspaceTsdk = true;
            experimental = {
              completion = { enableServerSideFuzzyMatch = true; };
            };
          };
          completions = { completeFunctionCalls = true; };
        };
      };

      nixd = {
        enable = true;
        settings = {
          nixd = {
            nixpkgs = { expr = "import <nixpkgs> { }"; };
            formatting = { command = [ "nixfmt" ]; };
            options = {
              nixos = {
                expr = ''
                  (builtins.getFlake "/etc/nixos").nixosConfigurations.HOSTNAME.options'';
              };
              home_manager = {
                expr = ''
                  (builtins.getFlake "/etc/nixos").homeConfigurations.USERNAME.options'';
              };
            };
          };
        };
      };

      # Rust LSP is handled by rustaceanvim plugin
      rust_analyzer = { enable = false; };
    };
  };
}
