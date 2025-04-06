local null_ls = require("null-ls")

return function(on_attach, capabilities)
  null_ls.setup({
    sources = {
      -- Nix
      null_ls.builtins.formatting.nixpkgs_fmt,
      null_ls.builtins.diagnostics.statix,

      -- Go
      null_ls.builtins.formatting.gofmt,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.golines,

      -- Go
      null_ls.builtins.formatting.prettier.with({
        command = "prettierd",
      }),

      -- Lua
      null_ls.builtins.formatting.stylua.with({
        extra_args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
          "--quote-style",
          "AutoPreferDouble",
          "--call-parentheses",
          "Always",
        },
      }),
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              filter = function(format_client)
                return format_client.name == "null-ls"
              end,
              timeout_ms = 2000,
            })
          end,
        })
      end
    end,
  })
end
