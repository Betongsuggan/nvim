# Rust (languages.rust): rustaceanvim runs rust-analyzer (and finds lldb-dap
# for its debuggables); crates.nvim manages Cargo.toml dependencies.
{ config, lib, ... }:
lib.mkIf config.languages.rust.enable {
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      tools = {
        hover_actions = {
          auto_focus = false;
          replace_builtin_hover = true;
        };
        code_action_group.enable = true;
      };

      # rustaceanvim manages rust-analyzer itself; the lspconfig server stays
      # off so it doesn't attach twice
      server = {
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
    };
  };

  # Cargo.toml: versions, features and upgrades inline, completion and
  # code actions through its in-process language server
  plugins.crates = {
    enable = true;
    lazyLoad.settings.event = {
      event = "BufRead";
      pattern = "Cargo.toml";
    };
    settings = {
      lsp = {
        enabled = true;
        actions = true;
        completion = true;
        hover = true;
      };
      popup.autofocus = false;
    };
  };
}
