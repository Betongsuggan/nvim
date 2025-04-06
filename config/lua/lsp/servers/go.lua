local lspconfig = require('lspconfig')

return function(on_attach, capabilities)
  lspconfig.gopls.setup({
    cmd = { "gopls" },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
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
  })
end
