local null_ls = require("null-ls")

return function(on_attach, capabilities)
  null_ls.setup({
    sources = {
      -- Nix
      null_ls.builtins.formatting.nixpkgs_fmt,
      null_ls.builtins.diagnostics.statix,

      -- Go
      null_ls.builtins.formatting.gofumpt, -- Add gofumpt for stricter formatting
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.golines.with({
        extra_args = {
          "--max-len=120",
          "--base-formatter=gofumpt", -- Ensure golines uses gofumpt as base
        },
      }),

      -- JavaScript/TypeScript

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
        -- Create a more robust formatting function
        local format_buffer = function()
          -- Save current view
          local view = vim.fn.winsaveview()

          -- Try to format with null-ls
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(format_client)
              return format_client.name == "null-ls"
            end,
            timeout_ms = 5000, -- Increased timeout for larger files
          })

          -- Restore view (cursor position, etc.)
          vim.fn.winrestview(view)
        end

        -- Create augroup for this buffer
        local augroup = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })

        -- Set up the autocmd
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = format_buffer,
        })
      end
    end,
  })
end
