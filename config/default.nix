{ pkgs, claudecode-nvim, ... }:
let theme = import ./theme.nix;
in {
  imports = [ ./options.nix ./plugins.nix ./keymaps.nix ];

  # Core nixvim configuration
  viAlias = true;
  vimAlias = true;

  # Colorscheme from theme
  colorschemes.${theme.name} = theme.colorscheme;

  # Terminal plugin
  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        width = { __raw = "math.floor(vim.o.columns * 0.8)"; };
        height = { __raw = "math.floor(vim.o.lines * 0.8)"; };
      };
      shell = "bash";
    };
  };

  # Include modular Lua files
  extraFiles = {
    "lua/testing/adapter.lua" = {
      text = builtins.readFile ../lua/testing/adapter.lua;
    };
    "lua/testing/registry.lua" = {
      text = builtins.readFile ../lua/testing/registry.lua;
    };
    "lua/testing/runner.lua" = {
      text = builtins.readFile ../lua/testing/runner.lua;
    };
    "lua/testing/ui.lua" = { text = builtins.readFile ../lua/testing/ui.lua; };
    "lua/testing/telescope.lua" = {
      text = builtins.readFile ../lua/testing/telescope.lua;
    };
    "lua/testing/adapters/go.lua" = {
      text = builtins.readFile ../lua/testing/adapters/go.lua;
    };
    "lua/testing/adapters/typescript.lua" = {
      text = builtins.readFile ../lua/testing/adapters/typescript.lua;
    };
  };

  # Additional packages needed by plugins
  extraPackages = with pkgs; [
    ripgrep # Required by telescope live_grep
    # Nerd Fonts for proper icon display
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    # Debugging tools
    delve # Go debugger
    nodejs_20 # Node.js runtime for TypeScript/JavaScript debugging
    lldb # LLVM debugger for Rust and C/C++
    # Formatters
    stylua # Lua formatter
    nixfmt-classic # Nix formatter
    prettierd # TypeScript/JavaScript formatter
    eslint_d # TypeScript/JavaScript linter
    # Rust tooling
    rust-analyzer # Rust language server
    rustfmt # Rust formatter
    clippy # Rust linter
    cargo # Rust package manager
    rustc # Rust compiler

    gcc
  ];

  # Extra plugins not available in nixvim
  extraPlugins = with pkgs.vimPlugins; [
    nvim-scrollbar

    # Popular colorschemes
    gruvbox-nvim # Gruvbox - retro groove colors
    tokyonight-nvim # Tokyo Night - modern dark theme
    nord-nvim # Nord - arctic, north-bluish theme
    onedark-nvim # OneDark - Atom's iconic One Dark theme
    nightfox-nvim # Nightfox - highly customizable theme
    dracula-nvim # Dracula - dark theme inspired by the famous color palette
    kanagawa-nvim # Kanagawa - inspired by the famous painting
    rose-pine # Rosé Pine - soho vibes theme

    # Testing and debugging plugins
    neotest-go # Go test adapter for neotest
    neotest-plenary # Plenary test adapter
    neotest-jest # Jest test adapter for TypeScript/JavaScript

    # Rust plugins
    rustaceanvim # Modern Rust development plugin with LSP enhancements
    crates-nvim # Cargo.toml dependency management

    # Claude Code integration
    (pkgs.vimUtils.buildVimPlugin {
      name = "claudecode-nvim";
      src = claudecode-nvim;
    })
  ];

  # Claude Code plugin configuration
  extraConfigLua = ''
    -- Setup claudecode.nvim
    require('claudecode').setup({
      terminal_cmd = nil, -- Auto-detect Claude CLI
      auto_start = true,
      log_level = "info",

      terminal = {
        provider = "native", -- Use native terminal for better session persistence
        auto_close = false,  -- Don't auto-close terminal to keep session alive
      },

      diff_opts = {
        auto_close_on_accept = true,
        auto_close_on_reject = true, -- Also close on reject for consistency
        vertical_split = false, -- Use horizontal split to give more width
        close_other_windows = false, -- Don't auto-close other windows
        focus_diff_window = true, -- Focus the diff window when opened
        diff_window_size = 0.8, -- Use 80% of screen for diff view
        on_new_file_reject = "close_window", -- Clean up rejected changes
        preview_context = 5, -- Show 5 lines of context around changes
        wrap_lines = false -- Don't wrap long lines in diff view
      }
    })

    -- Configure DAP for Rust debugging with LLDB
    local dap = require('dap')

    -- LLDB adapter for Rust
    dap.adapters.lldb = {
      type = 'executable',
      command = 'lldb-vscode', -- or 'lldb-dap' depending on your LLDB version
      name = 'lldb'
    }

    -- Rust debugging configuration
    dap.configurations.rust = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          -- Try to find the executable in target/debug
          local cwd = vim.fn.getcwd()
          local package_name = vim.fn.fnamemodify(cwd, ':t')
          local executable = cwd .. '/target/debug/' .. package_name

          -- Check if it exists, otherwise prompt
          if vim.fn.filereadable(executable) == 1 then
            return executable
          else
            return vim.fn.input('Path to executable: ', cwd .. '/target/debug/', 'file')
          end
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      },
      {
        name = 'Launch with arguments',
        type = 'lldb',
        request = 'launch',
        program = function()
          local cwd = vim.fn.getcwd()
          local package_name = vim.fn.fnamemodify(cwd, ':t')
          return cwd .. '/target/debug/' .. package_name
        end,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, " +")
        end,
        runInTerminal = false,
      },
    }

    -- Setup rustaceanvim
    -- This plugin automatically sets itself up and takes over rust-analyzer
    -- configuration, providing enhanced Rust development features
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        -- Hover actions
        hover_actions = {
          auto_focus = false, -- Don't auto-focus hover actions
          replace_builtin_hover = true, -- Replace built-in hover with rustacean hover
        },
        -- Code action group
        code_action_group = {
          enable = true,
        },
      },
      -- LSP configuration
      server = {
        -- rustaceanvim manages rust-analyzer directly
        -- NixVim's rust_analyzer is disabled to avoid duplicates
        on_attach = function(client, bufnr)
          -- Disable inlay hints by default for Rust (use keybind to toggle)
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end

          -- Additional Rust-specific keybindings
          local opts = { buffer = bufnr, silent = true }

          -- Hover with actions
          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, vim.tbl_extend("force", opts, { desc = "Hover Actions" }))

          -- Code actions
          vim.keymap.set("n", "<leader>la", function()
            vim.cmd.RustLsp("codeAction")
          end, vim.tbl_extend("force", opts, { desc = "Code Action" }))

          -- Runnables
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.RustLsp("runnables")
          end, vim.tbl_extend("force", opts, { desc = "Runnables" }))

          -- Debuggables
          vim.keymap.set("n", "<leader>rd", function()
            vim.cmd.RustLsp("debuggables")
          end, vim.tbl_extend("force", opts, { desc = "Debuggables" }))

          -- Expand macro
          vim.keymap.set("n", "<leader>re", function()
            vim.cmd.RustLsp("expandMacro")
          end, vim.tbl_extend("force", opts, { desc = "Expand Macro" }))

          -- Open Cargo.toml
          vim.keymap.set("n", "<leader>rc", function()
            vim.cmd.RustLsp("openCargo")
          end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

          -- Parent module
          vim.keymap.set("n", "<leader>rp", function()
            vim.cmd.RustLsp("parentModule")
          end, vim.tbl_extend("force", opts, { desc = "Parent Module" }))

          -- Join lines
          vim.keymap.set("n", "<leader>rj", function()
            vim.cmd.RustLsp("joinLines")
          end, vim.tbl_extend("force", opts, { desc = "Join Lines" }))

          -- View HIR
          vim.keymap.set("n", "<leader>rh", function()
            vim.cmd.RustLsp("view", "hir")
          end, vim.tbl_extend("force", opts, { desc = "View HIR" }))

          -- View MIR
          vim.keymap.set("n", "<leader>rm", function()
            vim.cmd.RustLsp("view", "mir")
          end, vim.tbl_extend("force", opts, { desc = "View MIR" }))

          -- Explain error
          vim.keymap.set("n", "<leader>rx", function()
            vim.cmd.RustLsp("explainError")
          end, vim.tbl_extend("force", opts, { desc = "Explain Error" }))

          -- Render diagnostics
          vim.keymap.set("n", "<leader>rD", function()
            vim.cmd.RustLsp("renderDiagnostic")
          end, vim.tbl_extend("force", opts, { desc = "Render Diagnostic" }))

          -- Move item up
          vim.keymap.set("n", "<leader>rU", function()
            vim.cmd.RustLsp("moveItem", "up")
          end, vim.tbl_extend("force", opts, { desc = "Move Item Up" }))

          -- Move item down
          vim.keymap.set("n", "<leader>rD", function()
            vim.cmd.RustLsp("moveItem", "down")
          end, vim.tbl_extend("force", opts, { desc = "Move Item Down" }))
        end,
        default_settings = {
          ['rust-analyzer'] = {
            -- Cargo configuration
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Procedural macros
            procMacro = {
              enable = true,
              attributes = { enable = true },
            },
            -- Check configuration (use clippy for better lints)
            check = {
              command = "clippy",
              allTargets = true,
              extraArgs = { "--no-deps" },
            },
            -- Diagnostics
            diagnostics = {
              enable = true,
              experimental = { enable = true },
              disabled = { "unresolved-proc-macro" },
              styleLints = { enable = true },
            },
            -- Completion
            completion = {
              autoimport = { enable = true },
              autoself = { enable = true },
              callable = { snippets = "fill_arguments" },
              postfix = { enable = true },
              privateEditable = { enable = false },
              fullFunctionSignatures = { enable = true },
            },
            -- Hover actions
            hover = {
              actions = {
                enable = true,
                run = { enable = true },
                debug = { enable = true },
                gotoTypeDef = { enable = true },
                implementations = { enable = true },
                references = { enable = true },
              },
              documentation = {
                enable = true,
                keywords = { enable = true },
              },
              links = { enable = true },
            },
            -- Inlay hints
            inlayHints = {
              bindingModeHints = { enable = false },
              chainingHints = { enable = true },
              closingBraceHints = { enable = true, minLines = 10 },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
              parameterHints = { enable = true },
              reborrowHints = { enable = "mutable" },
              typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
            },
            -- Lens (code lens for run/debug)
            lens = {
              enable = true,
              run = { enable = true },
              debug = { enable = true },
              implementations = { enable = true },
              references = {
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
              },
            },
            -- Semantic highlighting
            semanticHighlighting = {
              operator = { enable = true, specialization = { enable = true } },
              punctuation = {
                enable = true,
                separate = { macro = { bang = true } },
                specialization = { enable = true },
              },
            },
            -- Workspace symbol search
            workspace = {
              symbol = {
                search = { kind = "all_symbols", scope = "workspace_and_dependencies" },
              },
            },
            -- Rustfmt
            rustfmt = {
              extraArgs = { "+nightly" },
              rangeFormatting = { enable = true },
            },
            -- Files to watch
            files = {
              excludeDirs = { ".direnv", "rust-analyzer", "target" },
              watcher = "server",
            },
          },
        },
      },
      -- DAP configuration (will be set up separately)
      dap = {},
    }

    -- Setup crates.nvim for Cargo.toml management
    require('crates').setup({
      smart_insert = true, -- Use smart insert for version updates
      insert_closing_quote = true,
      autoload = true, -- Automatically load crate information
      autoupdate = true, -- Automatically update on save
      loading_indicator = true,
      date_format = "%Y-%m-%d", -- Date format for last updated
      thousands_separator = ".",
      notification_title = "Crates",
      text = {
        loading = "  Loading...",
        version = "  %s",
        prerelease = "  %s",
        yanked = "  %s yanked",
        nomatch = "  Not found",
        upgrade = "  %s",
        error = "  Error fetching crate",
      },
      popup = {
        autofocus = false,
        hide_on_select = true,
        copy_register = '"',
        style = "minimal",
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
      },
      completion = {
        cmp = {
          enabled = true, -- Enable nvim-cmp integration
        },
      },
    })

    -- Crates.nvim keybindings for Cargo.toml files
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Toggle extra information
        vim.keymap.set("n", "<leader>ct", function()
          require('crates').toggle()
        end, vim.tbl_extend("force", opts, { desc = "Toggle Crate Info" }))

        -- Reload crate information
        vim.keymap.set("n", "<leader>cr", function()
          require('crates').reload()
        end, vim.tbl_extend("force", opts, { desc = "Reload Crates" }))

        -- Show crate versions
        vim.keymap.set("n", "<leader>cv", function()
          require('crates').show_versions_popup()
        end, vim.tbl_extend("force", opts, { desc = "Show Versions" }))

        -- Show crate features
        vim.keymap.set("n", "<leader>cf", function()
          require('crates').show_features_popup()
        end, vim.tbl_extend("force", opts, { desc = "Show Features" }))

        -- Show crate dependencies
        vim.keymap.set("n", "<leader>cd", function()
          require('crates').show_dependencies_popup()
        end, vim.tbl_extend("force", opts, { desc = "Show Dependencies" }))

        -- Update crate
        vim.keymap.set("n", "<leader>cu", function()
          require('crates').update_crate()
        end, vim.tbl_extend("force", opts, { desc = "Update Crate" }))

        -- Update all crates
        vim.keymap.set("n", "<leader>cU", function()
          require('crates').update_all_crates()
        end, vim.tbl_extend("force", opts, { desc = "Update All Crates" }))

        -- Upgrade crate
        vim.keymap.set("n", "<leader>cg", function()
          require('crates').upgrade_crate()
        end, vim.tbl_extend("force", opts, { desc = "Upgrade Crate" }))

        -- Upgrade all crates
        vim.keymap.set("n", "<leader>cG", function()
          require('crates').upgrade_all_crates()
        end, vim.tbl_extend("force", opts, { desc = "Upgrade All Crates" }))

        -- Open documentation
        vim.keymap.set("n", "<leader>cD", function()
          require('crates').open_documentation()
        end, vim.tbl_extend("force", opts, { desc = "Open Documentation" }))

        -- Open homepage
        vim.keymap.set("n", "<leader>cH", function()
          require('crates').open_homepage()
        end, vim.tbl_extend("force", opts, { desc = "Open Homepage" }))

        -- Open repository
        vim.keymap.set("n", "<leader>cR", function()
          require('crates').open_repository()
        end, vim.tbl_extend("force", opts, { desc = "Open Repository" }))

        -- Enable cmp source for crates
        require('cmp').setup.buffer({
          sources = { { name = "crates" } }
        })
      end,
    })
  '';

  # Configure nvim-scrollbar with theme colors and theme switching
  # Configuration moved to individual plugin files for better organization
  # - Theme configuration: config/plugins/themes.nix
  # - UI/scrollbar configuration: config/plugins/ui-visual.nix
  # - Test configuration: config/plugins/testing-debug.nix
}
