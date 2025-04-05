local lsp = require('lspconfig')
local configs = require 'lspconfig/configs'

return function(on_attach, capabilities)
  lsp.gopls.setup {
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
end
