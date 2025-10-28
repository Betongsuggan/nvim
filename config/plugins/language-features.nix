{ ... }: {
  plugins = {
    # Syntax highlighting
    treesitter = {
      enable = true;
      settings = {
        highlight = { enable = true; };
        indent = { enable = true; };
        ensure_installed = [
          "go"
          "gomod"
          "gosum"
          "typescript"
          "tsx"
          "javascript"
          "lua"
          "nix"
          "bash"
          "json"
          "yaml"
          "markdown"
          "rust"
          "toml"
          "ron"
        ];
      };
    };

    # LSP Configuration
    lsp = {
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
              staticcheck = true; # Enable staticcheck for better diagnostics
              gofumpt = true;
              completionBudget = "100ms"; # Limit completion time
              matcher = "Fuzzy";
              # Auto-import settings
              completeUnimported =
                true; # Include unimported packages in completions
              deepCompletion = true; # Enable deep completions
              usePlaceholders = true; # Use placeholders in completions
              # Enhanced completion context
              completionDocumentation =
                true; # Include documentation in completions
              hoverKind = "FullDocumentation"; # Full documentation on hover
              linkTarget = "pkg.go.dev"; # Link to documentation
              # Interface implementation settings
              codelenses = {
                gc_details = false;
                generate = true;
                regenerate_cgo = true;
                run_govulncheck = false;
                test = true;
                tidy = true;
                upgrade_dependency = true;
                vendor = true;
              };
              semanticTokens = true;
              # Enable better symbol resolution
              symbolMatcher = "FastFuzzy";
              symbolStyle = "Dynamic";
            };
          };
          onAttach.function = ''
            -- Check if gopls is already running for this buffer
            local clients = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })
            if #clients > 1 then
              -- Stop duplicate clients, keeping only the first one
              for i = 2, #clients do
                vim.lsp.stop_client(clients[i].id, true)
              end
              return
            end

            -- Enhanced auto-import on completion confirm
            local orig_handler = vim.lsp.handlers["textDocument/completion"]
            vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
              if result and result.items then
                for _, item in ipairs(result.items) do
                  -- Mark items that need auto-import
                  if item.additionalTextEdits then
                    if not item.detail then item.detail = "" end
                    item.detail = item.detail .. " (auto-import)"
                  end
                end
              end
              return orig_handler(err, result, ctx, config)
            end

          '';
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
                insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis =
                  false;
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false;
                insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces =
                  false;
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
                insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis =
                  false;
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false;
                insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces =
                  false;
                placeOpenBraceOnNewLineForFunctions = false;
                placeOpenBraceOnNewLineForControlBlocks = false;
              };
              updateImportsOnFileMove = { enabled = "always"; };
            };
            completions = { completeFunctionCalls = true; };
          };
          onAttach.function = ''
            -- Enhanced auto-import on completion confirm for TypeScript
            local orig_handler = vim.lsp.handlers["textDocument/completion"]
            vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
              if result and result.items then
                for _, item in ipairs(result.items) do
                  -- Mark items that need auto-import
                  if item.additionalTextEdits then
                    if not item.detail then item.detail = "" end
                    item.detail = item.detail .. " (auto-import)"
                  end
                end
              end
              return orig_handler(err, result, ctx, config)
            end

            -- Enable inlay hints if supported
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
            end
          '';
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
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
          settings = {
            # Cargo configuration
            cargo = {
              allFeatures = true; # Enable all features for better completions
              loadOutDirsFromCheck = true; # Load OUT_DIR from check
              buildScripts = {
                enable = true; # Enable build script support
              };
            };
            # Procedural macros
            procMacro = {
              enable = true;
              attributes = { enable = true; };
            };
            # Check configuration
            check = {
              command = "clippy"; # Use clippy instead of check for better lints
              allTargets = true; # Check all targets
              extraArgs = [ "--no-deps" ]; # Don't check dependencies
            };
            # Diagnostics
            diagnostics = {
              enable = true;
              experimental = {
                enable = true; # Enable experimental diagnostics
              };
              disabled =
                [ "unresolved-proc-macro" ]; # Disable noisy diagnostics
              styleLints = {
                enable = true; # Enable style lints
              };
            };
            # Completion
            completion = {
              autoimport = { enable = true; };
              autoself = { enable = true; };
              callable = {
                snippets = "fill_arguments"; # Auto-fill function arguments
              };
              postfix = {
                enable = true; # Enable postfix completions (.if, .match, etc.)
              };
              privateEditable = {
                enable = false; # Don't suggest private items
              };
              fullFunctionSignatures = {
                enable = true; # Show full function signatures
              };
            };
            # Hover actions
            hover = {
              actions = {
                enable = true;
                run = { enable = true; };
                debug = { enable = true; };
                gotoTypeDef = { enable = true; };
                implementations = { enable = true; };
                references = { enable = true; };
              };
              documentation = {
                enable = true;
                keywords = { enable = true; };
              };
              links = { enable = true; };
            };
            # Inlay hints
            inlayHints = {
              bindingModeHints = {
                enable = false; # Disable binding mode hints (too noisy)
              };
              chainingHints = {
                enable = true; # Show type hints for method chains
              };
              closingBraceHints = {
                enable = true; # Show hints for closing braces
                minLines = 10; # Only for blocks with 10+ lines
              };
              closureReturnTypeHints = {
                enable = "always"; # Show closure return types
              };
              lifetimeElisionHints = {
                enable =
                  "skip_trivial"; # Show lifetime hints for non-trivial cases
                useParameterNames = true;
              };
              parameterHints = {
                enable = true; # Show parameter hints
              };
              reborrowHints = {
                enable = "mutable"; # Show reborrow hints for mutable refs
              };
              typeHints = {
                enable = true; # Show type hints
                hideClosureInitialization = false;
                hideNamedConstructor = false;
              };
            };
            # Lens (code lens for run/debug)
            lens = {
              enable = true;
              run = { enable = true; };
              debug = { enable = true; };
              implementations = { enable = true; };
              references = {
                adt = { enable = true; };
                enumVariant = { enable = true; };
                method = { enable = true; };
                trait = { enable = true; };
              };
            };
            # Semantic highlighting
            semanticHighlighting = {
              operator = {
                enable = true;
                specialization = { enable = true; };
              };
              punctuation = {
                enable = true;
                separate = { macro = { bang = true; }; };
                specialization = { enable = true; };
              };
            };
            # Workspace symbol search
            workspace = {
              symbol = {
                search = {
                  kind = "all_symbols";
                  scope = "workspace_and_dependencies";
                };
              };
            };
            # Rustfmt
            rustfmt = {
              extraArgs = [ "+nightly" ]; # Use nightly for better formatting
              overrideCommand = null;
              rangeFormatting = { enable = true; };
            };
            # Files to watch
            files = {
              excludeDirs = [ ".direnv" "rust-analyzer" "target" ];
              watcher = "server"; # Use server-side file watching
            };
          };
          onAttach.function = ''
            -- Disable inlay hints by default for Rust (use keybind to toggle)
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
            end

            -- Set up custom keybindings for Rust-specific features
            local bufnr = vim.api.nvim_get_current_buf()
            local opts = { buffer = bufnr, silent = true }

            -- These keybindings will be overridden by rustaceanvim if available
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, vim.tbl_extend("force", opts, { desc = "Rust Runnables" }))

            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, vim.tbl_extend("force", opts, { desc = "Rust Debuggables" }))

            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp("expandMacro")
            end, vim.tbl_extend("force", opts, { desc = "Expand Macro" }))

            vim.keymap.set("n", "<leader>rc", function()
              vim.cmd.RustLsp("openCargo")
            end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

            vim.keymap.set("n", "<leader>rp", function()
              vim.cmd.RustLsp("parentModule")
            end, vim.tbl_extend("force", opts, { desc = "Parent Module" }))

            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, vim.tbl_extend("force", opts, { desc = "Hover Actions" }))
          '';
        };
      };
    };

    # Autocompletion - Clean and simple
    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand =
            "function(args) require('luasnip').lsp_expand(args.body) end";
        };

        window = {
          completion = {
            border = "rounded";
            scrollbar = true;
          };
          documentation = {
            border = "rounded";
            max_height = 15;
            max_width = 60;
          };
        };

        # Vim-style and arrow key mappings
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(4)";
          "<C-u>" = "cmp.mapping.scroll_docs(-4)";
          "<C-y>" =
            "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" =
            "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })";
          "<Tab>" =
            "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() elseif require('luasnip').expand_or_jumpable() then require('luasnip').expand_or_jump() else fallback() end end, { 'i', 's' })";
          "<S-Tab>" =
            "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() elseif require('luasnip').jumpable(-1) then require('luasnip').jump(-1) else fallback() end end, { 'i', 's' })";
        };

        # Simple source priority
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            max_item_count = 5;
          }
          {
            name = "path";
            priority = 250;
          }
        ];

        # Custom sorting for modules, fields, methods priority
        sorting = {
          priority_weight = 1;
          comparators = [
            # Recently used items first (selected suggestion on top)
            {
              __raw = "require('cmp.config.compare').recently_used";
            }
            # Custom kind priority: modules, fields, methods
            {
              __raw = ''
                function(entry1, entry2)
                  local kind1 = entry1:get_kind()
                  local kind2 = entry2:get_kind()
                  local kind_priority = {
                    [require('cmp.types').lsp.CompletionItemKind.Module] = 1,
                    [require('cmp.types').lsp.CompletionItemKind.Field] = 2,
                    [require('cmp.types').lsp.CompletionItemKind.Property] = 2,
                    [require('cmp.types').lsp.CompletionItemKind.Method] = 3,
                    [require('cmp.types').lsp.CompletionItemKind.Function] = 4,
                  }
                  local priority1 = kind_priority[kind1] or 10
                  local priority2 = kind_priority[kind2] or 10
                  if priority1 ~= priority2 then
                    return priority1 < priority2
                  end
                end
              '';
            }
            # Default comparators for everything else
            { __raw = "require('cmp.config.compare').score"; }
            { __raw = "require('cmp.config.compare').offset"; }
            { __raw = "require('cmp.config.compare').order"; }
          ];
        };

        # Basic formatting with icons
        formatting = {
          fields = [ "kind" "abbr" "menu" ];
          format = {
            __raw = ''
              function(entry, vim_item)
                local lspkind = require('lspkind')
                local source_names = {
                  nvim_lsp = "[LSP]",
                  luasnip = "[Snip]", 
                  buffer = "[Buf]",
                  path = "[Path]"
                }

                vim_item = lspkind.cmp_format({
                  mode = 'symbol_text',
                  maxwidth = 50,
                })(entry, vim_item)

                vim_item.menu = source_names[entry.source.name] or ""
                return vim_item
              end
            '';
          };
        };

        # Performance settings
        performance = {
          debounce = 60;
          throttle = 30;
          fetching_timeout = 200;
          max_view_entries = 50;
        };

        # Basic completion behavior
        completion = {
          completeopt = "menu,menuone,noselect";
          keyword_length = 1;
        };
      };
    };

    # Snippet engine (required for cmp)
    luasnip = { enable = true; };

    # LSP UI improvements
    lspkind = {
      enable = true;
      cmp = {
        enable = false; # Disable auto-formatting to avoid conflicts
      };
    };
  };
}
