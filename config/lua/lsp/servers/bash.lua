local nvim_lsp = require('lspconfig')

return function(on_attach, capabilities)
  nvim_lsp.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end
