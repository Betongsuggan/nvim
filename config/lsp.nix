{
  config = {
    # LSP Configuration
    plugins = {
      # LSP
      lsp = {
        enable = true;

        servers = {
          # Go
          gopls = {
            enable = true;
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
                staticcheck = true;
                gofumpt = true;
                usePlaceholders = true;
                completeUnimported = true;
                directoryFilters = [
                  "-node_modules"
                  "-vendor"
                ];
                semanticTokens = true;
              };
            };
          };

          # Additional LSPs you might want
          # lua-ls = {
          #   enable = true;
          #   settings = {
          #     Lua = {
          #       workspace = {
          #         checkThirdParty = false;
          #       };
          #       completion = {
          #         callSnippet = "Replace";
          #       };
          #       diagnostics = {
          #         disable = [ "missing-fields" ];
          #       };
          #     };
          #   };
          # };

          # nil-ls = {
          #   enable = true;
          #   settings = {
          #     nil = {
          #       testSetting = 42;
          #       formatting = {
          #         command = [ "nixpkgs-fmt" ];
          #       };
          #     };
          #   };
          # };
        };

        # Global LSP settings
        onAttach = ''
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          
          -- Show LSP server capabilities for debugging
          if vim.env.DEBUG_LSP then
            print("LSP server attached: " .. client.name)
            print("Capabilities: " .. vim.inspect(client.server_capabilities))
          end
          
          -- Format on save for Go files (only if server supports formatting)
          if client.server_capabilities.documentFormattingProvider and client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
              buffer = bufnr,
              callback = function()
                if vim.bo[bufnr].filetype == "go" then
                  vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
                end
              end,
            })
          end
          
          -- Organize imports on save for Go files (only if server supports code actions)
          if client.server_capabilities.codeActionProvider and client.supports_method("textDocument/codeAction") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspOrganizeImports." .. bufnr, {}),
              buffer = bufnr,
              callback = function()
                if vim.bo[bufnr].filetype == "go" then
                  local params = vim.lsp.util.make_range_params()
                  params.context = {only = {"source.organizeImports"}}
                  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
                  if not result then return end
                  
                  for _, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                      if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                      elseif r.command then
                        vim.lsp.buf.execute_command(r.command)
                      end
                    end
                  end
                end
              end,
            })
          end
          
          -- NO KEYMAPS HERE - All keymaps are centralized in keymaps.nix
        '';

        # Capabilities - enhanced with nvim-cmp
        capabilities = ''
          capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        '';
      };

      # None-ls for additional formatting/linting
      none-ls = {
        enable = true;
        enableLspFormat = false; # We handle formatting in LSP onAttach
        sources = {
          formatting = {
            # Go
            gofumpt.enable = true;
            goimports.enable = true;

            # General
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            stylua.enable = true;
            nixpkgs_fmt.enable = true;
          };

          diagnostics = {
            golangci_lint.enable = true;
            statix.enable = true;
          };
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          snippet = {
            expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
          };

          completion = {
            completeopt = "menu,menuone,noinsert";
          };

          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require('luasnip').expand_or_jumpable() then
                  require('luasnip').expand_or_jump()
                else
                  fallback()
                end
              end, {'i', 's'})
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require('luasnip').jumpable(-1) then
                  require('luasnip').jump(-1)
                else
                  fallback()
                end
              end, {'i', 's'})
            '';
          };

          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];

          formatting = {
            format = ''
              function(entry, vim_item)
                local kind_icons = {
                  Text = "󰉿",
                  Method = "󰆧",
                  Function = "󰊕",
                  Constructor = "",
                  Field = " ",
                  Variable = "󰀫",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "󰑭",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈙",
                  Reference = "",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = " ",
                }
                
                vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  path = "[Path]",
                })[entry.source.name]
                return vim_item
              end
            '';
          };
        };
      };

      # Snippets
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
      };

      # LSP signature help
      lsp-signature = {
        enable = true;
        settings = {
          bind = true;
          handler_opts = {
            border = "rounded";
          };
          hint_enable = false;
        };
      };
    };

    # Go-specific configuration
    extraConfigLua = ''
      -- Go test configuration
      vim.api.nvim_create_user_command("GoTest", function()
        vim.cmd("!go test ./...")
      end, {})
      
      vim.api.nvim_create_user_command("GoTestFunc", function()
        local func_name = vim.fn.expand("<cword>")
        vim.cmd("!go test -run " .. func_name)
      end, {})
      
      -- Go build configuration
      vim.api.nvim_create_user_command("GoBuild", function()
        vim.cmd("!go build")
      end, {})
      
      -- Go run configuration
      vim.api.nvim_create_user_command("GoRun", function()
        vim.cmd("!go run .")
      end, {})
    '';
  };
}
