local nvim_lsp = require('lspconfig')

return function(on_attach, capabilities)
  nvim_lsp.kotlin_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "kotlin" },
    root_dir = nvim_lsp.util.root_pattern("settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git"),
  }
end
