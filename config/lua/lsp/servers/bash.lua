local lspconfig = require('lspconfig')

return function(on_attach, capabilities)
  lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "sh", "bash" },
    root_dir = lspconfig.util.root_pattern(".git", ".bashrc", ".bash_profile"),
  })
end
