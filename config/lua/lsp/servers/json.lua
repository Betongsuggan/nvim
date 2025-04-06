local nvim_lsp = require("lspconfig")

return function(on_attach, capabilities)
  nvim_lsp.jsonls.setup({
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  })
end
