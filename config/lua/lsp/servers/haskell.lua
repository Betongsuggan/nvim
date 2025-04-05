return function(on_attach, capabilities)
  vim.lsp.config['haskell-tools'] = {
    hls = {
      on_attach = on_attach,
      capabilities = capabilities
    }
  }

  vim.lsp.enable('haskell-tools')
end
