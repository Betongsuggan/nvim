# Rust: rustaceanvim (rust-analyzer frontend), crates.nvim (Cargo.toml),
# and the LLDB DAP wiring. Replaces lua/config/rust.lua.
{ ... }:
{
  # LLDB adapter + launch configurations for Rust debugging.
  plugins.dap = {
    adapters.executables.lldb = {
      command = "lldb-dap"; # binary name in nixpkgs lldb (lldb-vscode was renamed upstream)
    };
    configurations.rust = [
      {
        name = "Launch";
        type = "lldb";
        request = "launch";
        program.__raw = ''
          function()
            -- Try to find the executable in target/debug
            local cwd = vim.fn.getcwd()
            local package_name = vim.fn.fnamemodify(cwd, ":t")
            local executable = cwd .. "/target/debug/" .. package_name

            -- Check if it exists, otherwise prompt
            if vim.fn.filereadable(executable) == 1 then
              return executable
            else
              return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
            end
          end
        '';
        cwd.__raw = "vim.fn.getcwd()";
        stopOnEntry = false;
        args = [ ];
        runInTerminal = false;
      }
      {
        name = "Launch with arguments";
        type = "lldb";
        request = "launch";
        program.__raw = ''
          function()
            local cwd = vim.fn.getcwd()
            local package_name = vim.fn.fnamemodify(cwd, ":t")
            return cwd .. "/target/debug/" .. package_name
          end
        '';
        cwd.__raw = "vim.fn.getcwd()";
        stopOnEntry = false;
        args.__raw = ''
          function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end
        '';
        runInTerminal = false;
      }
    ];
  };

  plugins.rustaceanvim = {
    enable = true;
    settings = {
      # Plugin configuration
      tools = {
        hover_actions = {
          auto_focus = false; # Don't auto-focus hover actions
          replace_builtin_hover = true; # Replace built-in hover with rustacean hover
        };
        code_action_group = {
          enable = true;
        };
      };

      # LSP configuration — rustaceanvim manages rust-analyzer directly;
      # plugins.lsp.servers.rust_analyzer stays disabled to avoid duplicates.
      server = {
        on_attach.__raw = ''
          function(client, bufnr)
            -- Disable inlay hints by default for Rust (use keybind to toggle)
            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end

            -- Buffer-local Rust keybindings (<leader>r group; K and <leader>ca
            -- override the global LSP maps with the rustacean variants)
            local opts = { buffer = bufnr, silent = true }
            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
            end

            map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover Actions")
            map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code Action (Rust)")
            map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Runnables")
            map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
            map("<leader>re", function() vim.cmd.RustLsp("expandMacro") end, "Expand Macro")
            map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
            map("<leader>rp", function() vim.cmd.RustLsp("parentModule") end, "Parent Module")
            map("<leader>rj", function() vim.cmd.RustLsp("joinLines") end, "Join Lines")
            map("<leader>rh", function() vim.cmd.RustLsp("view", "hir") end, "View HIR")
            map("<leader>rm", function() vim.cmd.RustLsp("view", "mir") end, "View MIR")
            map("<leader>rx", function() vim.cmd.RustLsp("explainError") end, "Explain Error")
            map("<leader>rD", function() vim.cmd.RustLsp("renderDiagnostic") end, "Render Diagnostic")
            map("<leader>rU", function() vim.cmd.RustLsp("moveItem", "up") end, "Move Item Up")
            map("<leader>rN", function() vim.cmd.RustLsp("moveItem", "down") end, "Move Item Down")
          end
        '';
        default_settings = {
          rust-analyzer = {
            # Cargo configuration
            cargo = {
              allFeatures = true;
              loadOutDirsFromCheck = true;
              buildScripts = {
                enable = true;
              };
            };
            # Procedural macros
            procMacro = {
              enable = true;
              attributes = {
                enable = true;
              };
            };
            # Check configuration (use clippy for better lints)
            check = {
              command = "clippy";
              allTargets = true;
              extraArgs = [ "--no-deps" ];
            };
            # Diagnostics
            diagnostics = {
              enable = true;
              experimental = {
                enable = true;
              };
              disabled = [ "unresolved-proc-macro" ];
              styleLints = {
                enable = true;
              };
            };
            # Completion
            completion = {
              autoimport = {
                enable = true;
              };
              autoself = {
                enable = true;
              };
              callable = {
                snippets = "fill_arguments";
              };
              postfix = {
                enable = true;
              };
              privateEditable = {
                enable = false;
              };
              fullFunctionSignatures = {
                enable = true;
              };
            };
            # Hover actions
            hover = {
              actions = {
                enable = true;
                run = {
                  enable = true;
                };
                debug = {
                  enable = true;
                };
                gotoTypeDef = {
                  enable = true;
                };
                implementations = {
                  enable = true;
                };
                references = {
                  enable = true;
                };
              };
              documentation = {
                enable = true;
                keywords = {
                  enable = true;
                };
              };
              links = {
                enable = true;
              };
            };
            # Inlay hints
            inlayHints = {
              bindingModeHints = {
                enable = false;
              };
              chainingHints = {
                enable = true;
              };
              closingBraceHints = {
                enable = true;
                minLines = 10;
              };
              closureReturnTypeHints = {
                enable = "always";
              };
              lifetimeElisionHints = {
                enable = "skip_trivial";
                useParameterNames = true;
              };
              parameterHints = {
                enable = true;
              };
              reborrowHints = {
                enable = "mutable";
              };
              typeHints = {
                enable = true;
                hideClosureInitialization = false;
                hideNamedConstructor = false;
              };
            };
            # Lens (code lens for run/debug)
            lens = {
              enable = true;
              run = {
                enable = true;
              };
              debug = {
                enable = true;
              };
              implementations = {
                enable = true;
              };
              references = {
                adt = {
                  enable = true;
                };
                enumVariant = {
                  enable = true;
                };
                method = {
                  enable = true;
                };
                trait = {
                  enable = true;
                };
              };
            };
            # Semantic highlighting
            semanticHighlighting = {
              operator = {
                enable = true;
                specialization = {
                  enable = true;
                };
              };
              punctuation = {
                enable = true;
                separate = {
                  macro = {
                    bang = true;
                  };
                };
                specialization = {
                  enable = true;
                };
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
            # Whole-file rustfmt only: range formatting needs a nightly
            # rustfmt (`+nightly` is rustup syntax and fails with Nix's)
            # Files to watch
            files = {
              excludeDirs = [
                ".direnv"
                "rust-analyzer"
                "target"
              ];
              watcher = "server";
            };
          };
        };
      };

      # DAP handled by plugins.dap above
      dap = { };
    };
  };

  # crates.nvim for Cargo.toml management
  plugins.crates = {
    enable = true;
    settings = {
      smart_insert = true; # Use smart insert for version updates
      insert_closing_quote = true;
      autoload = true; # Automatically load crate information
      autoupdate = true; # Automatically update on save
      loading_indicator = true;
      date_format = "%Y-%m-%d"; # Date format for last updated
      thousands_separator = ".";
      notification_title = "Crates";
      text = {
        loading = "  Loading...";
        version = "  %s";
        prerelease = "  %s";
        yanked = "  %s yanked";
        nomatch = "  Not found";
        upgrade = "  %s";
        error = "  Error fetching crate";
      };
      popup = {
        autofocus = false;
        hide_on_select = true;
        copy_register = "\"";
        style = "minimal";
        border = "rounded";
        show_version_date = true;
        show_dependency_version = true;
        max_height = 30;
        min_width = 20;
        padding = 1;
      };
      lsp = {
        enabled = true;
        actions = true;
        completion = true;
        hover = true;
      };
    };
  };

  # Crates keybindings, buffer-local on Cargo.toml. Under <leader>C (not
  # <leader>c) so they don't shadow the global Code group — the old
  # <leader>cR binding made Snacks rename_file unreachable in Cargo.toml.
  autoCmd = [
    {
      event = [ "BufRead" ];
      group = "CratesKeymaps";
      pattern = [ "Cargo.toml" ];
      callback.__raw = ''
        function()
          local opts = { buffer = true, silent = true }
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, function()
              require("crates")[rhs]()
            end, vim.tbl_extend("force", opts, { desc = desc }))
          end

          map("<leader>Ct", "toggle", "Toggle Crate Info")
          map("<leader>CR", "reload", "Reload Crates")
          map("<leader>Cv", "show_versions_popup", "Show Versions")
          map("<leader>CF", "show_features_popup", "Show Features")
          map("<leader>Cd", "show_dependencies_popup", "Show Dependencies")
          map("<leader>Cu", "update_crate", "Update Crate")
          map("<leader>CU", "update_all_crates", "Update All Crates")
          map("<leader>Cg", "upgrade_crate", "Upgrade Crate")
          map("<leader>CG", "upgrade_all_crates", "Upgrade All Crates")
          map("<leader>CD", "open_documentation", "Open Documentation")
          map("<leader>CH", "open_homepage", "Open Homepage")
          map("<leader>CP", "open_repository", "Open Repository")
        end
      '';
    }
  ];

  autoGroups.CratesKeymaps = {
    clear = true;
  };
}
