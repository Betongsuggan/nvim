{ ... }: {
  plugins = {
    # File finder and navigation
    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          prompt_prefix = " ";
          selection_caret = "> ";
          entry_prefix = "  ";
          initial_mode = "insert";
          path_display = [ "truncate" ];
          sorting_strategy = "ascending";
          borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
          dynamic_preview_title = true;
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
        };
        pickers = {
          diagnostics = {
            theme = "dropdown";
            initial_mode = "normal";
            layout_config = {
              preview_cutoff = 9999;
            };
          };
        };
      };
    };

    # Syntax highlighting
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
        };
        indent = {
          enable = true;
        };
        ensure_installed = [
          "go"
          "gomod"
          "gosum"
          "lua"
          "nix"
          "bash"
          "json"
          "yaml"
          "markdown"
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
                unreachable = false; # Disable expensive analysis
              };
              staticcheck = false; # Disable for faster completion
              gofumpt = true;
              completionBudget = "100ms"; # Limit completion time
              matcher = "Fuzzy";
              # Auto-import settings
              completeUnimported = true; # Include unimported packages in completions
              deepCompletion = true; # Enable deep completions
              usePlaceholders = true; # Use placeholders in completions
              # Enhanced completion context
              completionDocumentation = true; # Include documentation in completions
              hoverKind = "FullDocumentation"; # Full documentation on hover
              linkTarget = "pkg.go.dev"; # Link to documentation
            };
          };
          onAttach.function = ''
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
        nixd = {
          enable = true;
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }";
              };
              formatting = {
                command = [ "nixfmt" ];
              };
              options = {
                nixos = {
                  expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.HOSTNAME.options";
                };
                home_manager = {
                  expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.USERNAME.options";
                };
              };
            };
          };
        };
      };
    };

    # Autocompletion - Clean and simple
    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
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
          "<C-y>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })";
          "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() elseif require('luasnip').expand_or_jumpable() then require('luasnip').expand_or_jump() else fallback() end end, { 'i', 's' })";
          "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() elseif require('luasnip').jumpable(-1) then require('luasnip').jump(-1) else fallback() end end, { 'i', 's' })";
        };

        # Simple source priority
        sources = [
          { name = "nvim_lsp"; priority = 1000; }
          { name = "luasnip"; priority = 750; }
          { name = "buffer"; priority = 500; max_item_count = 5; }
          { name = "path"; priority = 250; }
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
            {
              __raw = "require('cmp.config.compare').score";
            }
            {
              __raw = "require('cmp.config.compare').offset";
            }
            {
              __raw = "require('cmp.config.compare').order";
            }
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
    luasnip = {
      enable = true;
    };

    # Auto-pairing for brackets, quotes, etc.
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        disable_filetype = [ "TelescopePrompt" ];
        map_cr = true;
        map_bs = true;
        enable_check_bracket_line = false;
      };
    };

    # Surround functionality (add/change/delete surrounding chars)
    nvim-surround = {
      enable = true;
      settings = {
        keymaps = {
          insert = "<C-g>s";
          insert_line = "<C-g>S";
          normal = "ys";
          normal_cur = "yss";
          normal_line = "yS";
          normal_cur_line = "ySS";
          visual = "S";
          visual_line = "gS";
          delete = "ds";
          change = "cs";
          change_line = "cS";
        };
      };
    };

    # Comment toggling
    comment = {
      enable = true;
      settings = {
        padding = true;
        sticky = true;
        toggler = {
          line = "<leader>c/";
          block = "<leader>c?";
        };
        opleader = {
          line = "<leader>c/";
          block = "<leader>c?";
        };
        extra = {
          above = "<leader>cO";
          below = "<leader>cb";
          eol = "<leader>cA";
        };
      };
    };

    # LSP UI improvements
    lspkind = {
      enable = true;
      cmp = {
        enable = false; # Disable auto-formatting to avoid conflicts
      };
    };

    # Icons (required by telescope and other plugins)
    web-devicons = {
      enable = true;
    };

    # File explorer
    neo-tree = {
      enable = true;
      closeIfLastWindow = false;
      popupBorderStyle = "rounded";
      enableGitStatus = true;
      enableDiagnostics = true;
      window = {
        position = "float";
        width = 50;
        mappings = {
          "o" = "open";
          "<CR>" = "open";
        };
        mappingOptions = {
          noremap = true;
          nowait = true;
        };
      };
    };

    # Indent guides for better code visualization
    #indent-blankline = {
    #  enable = true;
    #  settings = {
    #    indent = {
    #      char = "│";
    #      tab_char = "│";
    #    };
    #    whitespace = {
    #      remove_blankline_trail = false;
    #    };
    #    scope = {
    #      enabled = true;
    #      char = "│";
    #      show_start = true;
    #      show_end = true;
    #    };
    #  };
    #};

    # Which-Key for keymap discovery
    which-key = {
      enable = true;
      settings = {
        delay = 500;
        expand = 1;
        notify = false;
        preset = "modern";
        replace = {
          desc = [
            [ "<space>" " " ]
            [ "<leader>" " " ]
            [ "<[cC][rR]>" " " ]
            [ "<[tT][aA][bB]>" " " ]
            [ "<[bB][sS]>" " " ]
          ];
        };
        spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
            icon = "🔍";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
            icon = "💻";
          }
          {
            __unkeyed-1 = "<leader>p";
            group = "Project";
            icon = "📦";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffer";
            icon = "📄";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git";
            icon = "🌿";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "Windows";
            icon = "🪟";
          }
        ];
        win = {
          border = "rounded";
          padding = [ 1 2 ];
        };
      };
    };

    # Git signs for signcolumn
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "+";
          };
          change = {
            text = "~";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
          untracked = {
            text = "?";
          };
        };
        signcolumn = true;
        numhl = false;
        linehl = false;
        word_diff = false;
        watch_gitdir = {
          follow_files = true;
        };
        attach_to_untracked = false;
        current_line_blame = false;
        sign_priority = 6;
        update_debounce = 300;
        status_formatter = null;
        max_file_length = 40000;
        preview_config = {
          border = "rounded";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        };
      };
    };

    # Buffer tabline for open buffer visualization  
    bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          themable = true;
          numbers = "none";
          close_command = "bdelete! %d";
          right_mouse_command = "bdelete! %d";
          left_mouse_command = "buffer %d";
          middle_mouse_command = null;
          indicator = {
            icon = "▎";
            style = "icon";
          };
          buffer_close_icon = "󰅖";
          modified_icon = "●";
          close_icon = "";
          left_trunc_marker = "";
          right_trunc_marker = "";
          max_name_length = 30;
          max_prefix_length = 30;
          tab_size = 21;
          diagnostics = "nvim_lsp";
          diagnostics_update_in_insert = false;
          diagnostics_indicator = {
            __raw = ''
              function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and "🚨 " or 
                           level:match("warning") and "⚠️ " or "💡 "
                return " " .. icon .. count
              end
            '';
          };
          color_icons = true;
          show_buffer_icons = true;
          show_buffer_close_icons = true;
          show_close_icon = true;
          show_tab_indicators = true;
          persist_buffer_sort = true;
          separator_style = "thick";
          enforce_regular_tabs = true;
          always_show_bufferline = true;
          sort_by = "insert_after_current";
        };
      };
    };


    # Symbol outline for code navigation
    aerial = {
      enable = true;
      settings = {
        backends = [ "lsp" "treesitter" "markdown" "asciidoc" "man" ];
        layout = {
          max_width = [ 40 0.2 ];
          width = null;
          min_width = 10;
          win_opts = {};
          default_direction = "prefer_right";
          placement = "window";
          preserve_equality = false;
        };
        attach_mode = "window";
        close_automatic_events = [ "unfocus" ];
        keymaps = {
          "?" = "actions.show_help";
          "g?" = "actions.show_help";
          "<CR>" = "actions.jump";
          "<2-LeftMouse>" = "actions.jump";
          "<C-v>" = "actions.jump_vsplit";
          "<C-s>" = "actions.jump_split";
          "p" = "actions.scroll";
          "<C-j>" = "actions.down_and_scroll";
          "<C-k>" = "actions.up_and_scroll";
          "{" = "actions.prev";
          "}" = "actions.next";
          "[[" = "actions.prev_up";
          "]]" = "actions.next_up";
          "q" = "actions.close";
          "o" = "actions.tree_toggle";
          "za" = "actions.tree_toggle";
          "O" = "actions.tree_toggle_recursive";
          "zA" = "actions.tree_toggle_recursive";
          "l" = "actions.tree_open";
          "zo" = "actions.tree_open";
          "L" = "actions.tree_open_recursive";
          "zO" = "actions.tree_open_recursive";
          "h" = "actions.tree_close";
          "zc" = "actions.tree_close";
          "H" = "actions.tree_close_recursive";
          "zC" = "actions.tree_close_recursive";
          "zr" = "actions.tree_increase_fold_level";
          "zR" = "actions.tree_open_all";
          "zm" = "actions.tree_decrease_fold_level";
          "zM" = "actions.tree_close_all";
          "zx" = "actions.tree_sync_folds";
          "zX" = "actions.tree_sync_folds";
        };
        lazy_load = true;
        disable_max_lines = 10000;
        disable_max_size = 2000000;
        filter_kind = [
          "Class"
          "Constructor" 
          "Enum"
          "Function"
          "Interface" 
          "Module"
          "Method"
          "Struct"
        ];
        highlight_mode = "split_width";
        highlight_closest = true;
        highlight_on_hover = false;
        highlight_on_jump = 300;
        autojump = false;
        icons = {};
        ignore = {
          unlisted_buffers = false;
          diff_windows = true;
          filetypes = [];
          buftypes = "special";
          wintypes = "special";
        };
        manage_folds = false;
        link_folds_to_tree = false;
        link_tree_to_folds = true;
        nerd_font = "auto";
        on_attach = {
          __raw = ''
            function(bufnr)
              vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
              vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end
          '';
        };
        open_automatic = false;
        post_jump_cmd = "normal! zz";
        close_on_select = false;
        update_events = "TextChanged,InsertLeave";
        show_guides = false;
        float = {
          border = "rounded";
          relative = "cursor";
          max_height = 0.9;
          height = null;
          min_height = [ 8 0.1 ];
          override = {
            __raw = ''
              function(conf, source_winid)
                conf.anchor = "NE"
                conf.col = conf.col + 1
                conf.row = conf.row + 1
                return conf
              end
            '';
          };
        };
        lsp = {
          diagnostics_trigger_update = true;
          update_when_errors = true;
          update_delay = 300;
          priority = {
            __raw = ''
              {
                -- You can set a priority for certain symbols
                Class = 10,
                Constructor = 10,
                Enum = 10,
                Function = 10,
                Interface = 10,
                Module = 10,
                Method = 10,
                Struct = 10,
              }
            '';
          };
        };
        treesitter = {
          update_delay = 300;
        };
        markdown = {
          update_delay = 300;
        };
      };
    };


    # Better diagnostics and quick fix navigation
    trouble = {
      enable = true;
      settings = {
        modes = {
          diagnostics = {
            mode = "diagnostics";
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [ 0 2 ];
              size = { width = 0.4; height = 0.4; };
              zindex = 200;
            };
          };
          buffer_diagnostics = {
            mode = "diagnostics";
            filter = {
              buf = 0;
            };
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [ 0 2 ];
              size = { width = 0.4; height = 0.4; };
              zindex = 200;
            };
          };
        };
        icons = {
          indent = {
            top = "│ ";
            middle = "├╴";
            last = "└╴";
            fold_open = " ";
            fold_closed = " ";
            ws = "  ";
          };
          folder_closed = " ";
          folder_open = " ";
          kinds = {
            Array = " ";
            Boolean = "󰨙 ";
            Class = " ";
            Constant = "󰏿 ";
            Constructor = " ";
            Enum = " ";
            EnumMember = " ";
            Event = " ";
            Field = " ";
            File = " ";
            Function = "󰊕 ";
            Interface = " ";
            Key = " ";
            Method = "󰊕 ";
            Module = " ";
            Namespace = "󰦮 ";
            Null = " ";
            Number = "󰎠 ";
            Object = " ";
            Operator = " ";
            Package = " ";
            Property = " ";
            String = " ";
            Struct = "󰆼 ";
            TypeParameter = " ";
            Variable = "󰀫 ";
          };
        };
        win = { 
          border = "rounded";
          type = "float";
          relative = "editor";
          position = "50%";
          size = { width = 0.8; height = 0.8; };
          zindex = 50;
        };
        preview = {
          type = "float";
          relative = "editor";
          border = "rounded";
          title = "Preview";
          title_pos = "center";
          position = [ 0 2 ];
          size = { width = 0.4; height = 0.4; };
          zindex = 100;
        };
        throttle = {
          refresh = 20;
          update = 10;
          render = 10;
          follow = 100;
          preview = { ms = 100; debounce = true; };
        };
        keys = {
          "?" = "help";
          r = "refresh";
          R = "toggle_refresh";
          q = "close";
          o = "jump_close";
          "<esc>" = "close";
          "<cr>" = "jump";
          "<2-leftmouse>" = "jump";
          "<c-s>" = "jump_split";
          "<c-v>" = "jump_vsplit";
          "}" = "next";
          "]]" = "next";
          "{" = "prev";
          "[[" = "prev";
          dd = "delete";
          d = { action = "delete"; mode = "v"; };
          i = "inspect";
          p = "preview";
          P = "toggle_preview";
          zo = "fold_open";
          zO = "fold_open_recursive";
          zc = "fold_close";
          zC = "fold_close_recursive";
          za = "fold_toggle";
          zA = "fold_toggle_recursive";
          zm = "fold_more";
          zM = "fold_close_all";
          zr = "fold_reduce";
          zR = "fold_open_all";
          zx = "fold_update";
          zX = "fold_update_all";
          zn = "fold_disable";
          zN = "fold_enable";
          zi = "fold_toggle_enable";
        };
      };
    };

    # Lualine status bar with emoji indicators
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "catppuccin";
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          globalstatus = true;
          refresh = {
            statusline = 1000;
            tabline = 1000;
            winbar = 1000;
          };
        };
        sections = {
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              separator = {
                left = "";
              };
              right_padding = 2;
            }
          ];
          lualine_b = [
            {
              __unkeyed-1 = "filename";
              symbols = {
                modified = "●";
                readonly = "🔒";
                unnamed = "📝";
                newfile = "✨";
              };
            }
          ];
          lualine_c = [
            {
              __unkeyed-1 = "branch";
              icon = "🌿";
            }
            {
              __unkeyed-1 = "diff";
              symbols = {
                added = "✅ ";
                modified = "⚡ ";
                removed = "❌ ";
              };
            }
            {
              __unkeyed-1 = {
                __raw = ''
                  function()
                    local aerial_ok, aerial = pcall(require, "aerial")
                    if aerial_ok then
                      local symbol = aerial.get_location(true)
                      if symbol and symbol ~= "" then
                        return "📍 " .. symbol
                      end
                    end
                    return ""
                  end
                '';
              };
              cond = {
                __raw = ''
                  function()
                    local aerial_ok, aerial = pcall(require, "aerial")
                    return aerial_ok and aerial.get_location(true) ~= ""
                  end
                '';
              };
            }
          ];
          lualine_x = [
            {
              __unkeyed-1 = "diagnostics";
              sources = [ "nvim_diagnostic" "nvim_lsp" ];
              symbols = {
                error = "🚨 ";
                warn = "⚠️ ";
                info = "💡 ";
                hint = "💭 ";
              };
            }
            {
              __unkeyed-1 = "encoding";
              fmt = {
                __raw = "string.upper";
              };
            }
            {
              __unkeyed-1 = "fileformat";
              symbols = {
                unix = "🐧";
                dos = "🪟";
                mac = "🍎";
              };
            }
            "filetype"
          ];
          lualine_y = [
            "progress"
          ];
          lualine_z = [
            {
              __unkeyed-1 = "location";
              separator = {
                right = "";
              };
              left_padding = 2;
            }
          ];
        };
        inactive_sections = {
          lualine_a = [ "filename" ];
          lualine_b = [ ];
          lualine_c = [ ];
          lualine_x = [ ];
          lualine_y = [ ];
          lualine_z = [ "location" ];
        };
      };
    };
  };
}
