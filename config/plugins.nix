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
          selection_caret = " ";
          path_display = ["truncate"];
          sorting_strategy = "ascending";
          borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
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
                unreachable = true;
              };
              staticcheck = true;
              gofumpt = true;
            };
          };
        };
      };
    };

    # Autocompletion
    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
        };
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
          "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
      };
    };

    # Snippet engine (required for cmp)
    luasnip = {
      enable = true;
    };

    # LSP UI improvements
    lspkind = {
      enable = true;
    };

    # Icons (required by telescope and other plugins)
    web-devicons = {
      enable = true;
    };

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
            __unkeyed-1 = "<leader>l";
            group = "LSP";
            icon = "🔧";
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
            text = "✅";
          };
          change = {
            text = "⚡";
          };
          delete = {
            text = "❌";
          };
          topdelete = {
            text = "🔺";
          };
          changedelete = {
            text = "🔄";
          };
          untracked = {
            text = "❓";
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
        update_debounce = 100;
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
          lualine_b = [];
          lualine_c = [];
          lualine_x = [];
          lualine_y = [];
          lualine_z = [ "location" ];
        };
      };
    };
  };
}