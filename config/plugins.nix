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
        ];
        win = {
          border = "rounded";
          padding = [ 1 2 ];
        };
      };
    };
  };
}