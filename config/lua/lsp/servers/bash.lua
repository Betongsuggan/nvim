return function(on_attach, capabilities)
  vim.lsp.config['bashls'] = {
    on_attach = on_attach,
    capabilities = capabilities
  }

  vim.lsp.enable('gopls')
end
