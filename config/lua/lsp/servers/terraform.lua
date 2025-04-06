local nvim_lsp = require('lspconfig')

return function(on_attach, capabilities)
  nvim_lsp.terraformls.setup {
    filetypes = { "terraform", "terraform-vars", "tf" },
    root_dir = nvim_lsp.util.root_pattern(".terraform", ".git"),
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*.tf", "*.tfvars" },
        callback = function() vim.lsp.buf.format() end,
      })
      on_attach(client, bufnr)
    end
  }
end
