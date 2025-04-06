local nvim_lsp = require('lspconfig')

return function(on_attach, capabilities)
  nvim_lsp.java_language_server.setup {
    cmd = { 'java-language-server' },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "java" },
    root_dir = nvim_lsp.util.root_pattern("pom.xml", "build.gradle", ".git", "mvnw", "gradlew"),
  }
end
