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
              unreachable = false; # Disable expensive analysis
            };
            staticcheck = false; # Disabled for performance
            gofumpt = true;
            completionBudget = "100ms";
            matcher = "Fuzzy";
            completeUnimported = true;
            deepCompletion = false; # Disabled for performance
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

      ts_ls = {
        enable = true;
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = false;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
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
            format = {
              enable = true;
              insertSpaceAfterCommaDelimiter = true;
              insertSpaceAfterSemicolonInForStatements = true;
              insertSpaceBeforeAndAfterBinaryOperators = true;
              insertSpaceAfterConstructor = false;
              insertSpaceAfterKeywordsInControlFlowStatements = true;
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true;
              insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false;
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false;
              insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false;
              placeOpenBraceOnNewLineForFunctions = false;
              placeOpenBraceOnNewLineForControlBlocks = false;
            };
            updateImportsOnFileMove = { enabled = "always"; };
            workspaceSymbols = { scope = "allOpenProjects"; };
          };
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = false;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
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
            format = {
              enable = true;
              insertSpaceAfterCommaDelimiter = true;
              insertSpaceAfterSemicolonInForStatements = true;
              insertSpaceBeforeAndAfterBinaryOperators = true;
              insertSpaceAfterConstructor = false;
              insertSpaceAfterKeywordsInControlFlowStatements = true;
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true;
              insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false;
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false;
              insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false;
              placeOpenBraceOnNewLineForFunctions = false;
              placeOpenBraceOnNewLineForControlBlocks = false;
            };
            updateImportsOnFileMove = { enabled = "always"; };
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
