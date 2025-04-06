local lspconfig = require('lspconfig')

return function(on_attach, capabilities)
  lspconfig.hls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "haskell", "lhaskell", "cabal" },
    root_dir = lspconfig.util.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git"),
  })
end
