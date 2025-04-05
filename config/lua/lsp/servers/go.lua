return function(on_attach, capabilities)
  vim.lsp.config['gopls'] = {
    cmd = { "gopls" },
    on_attach = on_attach,
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        gofumpt = true,
        analyses = {
          unusedparams = true,
          shadow = true,
          nilaway = true,
        },
        staticcheck = true,
      },
    },
  }

  vim.lsp.enable('gopls')
end
