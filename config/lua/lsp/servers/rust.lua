return function(on_attach, capabilities)
  local lspconfig = require('lspconfig')

  lspconfig.rust_analyzer.setup({
    cmd = { "rust-analyzer" },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "rust" },
    root_dir = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
    settings = {
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
        check = {
          command = "clippy",
        },
        -- Inlay hints configuration
        inlayHints = {
          parameterHints = { enable = false },
          typeHints = { enable = true },
          chainingHints = { enable = true },
        },
      },
    },
    flags = {
      debounce_text_changes = 150,
    },
  })
end
