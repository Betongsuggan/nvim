# Autocompletion configuration (cmp, luasnip)
{ ... }: {
  plugins = {
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

        sources = [
          { name = "nvim_lsp"; priority = 1000; }
          { name = "luasnip"; priority = 750; }
          { name = "buffer"; priority = 500; max_item_count = 5; }
          { name = "path"; priority = 250; }
        ];

        sorting = {
          priority_weight = 1;
          comparators = [
            { __raw = "require('cmp.config.compare').recently_used"; }
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
            { __raw = "require('cmp.config.compare').score"; }
            { __raw = "require('cmp.config.compare').offset"; }
            { __raw = "require('cmp.config.compare').order"; }
          ];
        };

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

        performance = {
          debounce = 60;
          throttle = 30;
          fetching_timeout = 200;
          max_view_entries = 50;
        };

        completion = {
          completeopt = "menu,menuone,noselect";
          keyword_length = 1;
        };
      };
    };

    luasnip = { enable = true; };

    lspkind = {
      enable = true;
      cmp = { enable = false; };
    };
  };
}
